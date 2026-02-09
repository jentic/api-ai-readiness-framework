#!/bin/bash
# publish-to-docs.sh
# Publishes API AI-Readiness Framework specification to jentic-docs repository

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse arguments
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    shift
fi

COMMIT_SHA=${1:?"Usage: $0 [--dry-run] <commit-sha> <github-token>"}
GH_TOKEN=${2:?"Usage: $0 [--dry-run] <commit-sha> <github-token>"}

echo -e "${GREEN}=== Publishing API AI-Readiness Framework Specification ===${NC}"

# Ensure we're in the repo root
cd "$(dirname "$0")/.."
REPO_ROOT=$(pwd)

# Extract version from spec.md (line 3: ## Version X.Y.Z)
echo "Extracting version from spec.md..."
VERSION=$(grep -m 1 "^## Version" docs/specification/spec.md | sed 's/## Version //')
if [ -z "$VERSION" ]; then
    echo -e "${RED}❌ Failed to extract version from spec.md${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Version: ${VERSION}${NC}"

# Generate timestamp
TIMESTAMP=$(date -u +"%Y-%m-%d")
BRANCH_NAME="update-api-readiness-spec-v${VERSION}"

echo "Timestamp: ${TIMESTAMP}"
echo "Branch name: ${BRANCH_NAME}"
echo "Commit SHA: ${COMMIT_SHA:0:8}"

# Create temporary working directory
WORK_DIR=$(mktemp -d -t spec-publish-XXXXXX)
echo "Working directory: ${WORK_DIR}"

# Cleanup function
cleanup() {
    if [ "$DRY_RUN" = false ]; then
        echo "🧹 Cleaning up..."
        rm -rf "${WORK_DIR}"
    else
        echo -e "${YELLOW}Dry-run: Keeping work directory at ${WORK_DIR}${NC}"
    fi
}
trap cleanup EXIT

# Prepare content
echo ""
echo "Preparing content..."
mkdir -p "${WORK_DIR}/content"

# Copy specification
echo "  - Copying spec.md → specification.md"
cp docs/specification/spec.md "${WORK_DIR}/content/specification.md"

# Remove Table of Contents section (MkDocs generates its own)
echo "  - Removing Table of Contents section"
sed -i.bak '/<!-- TOC/,/<!-- \/TOC-->/d' "${WORK_DIR}/content/specification.md"
sed -i.bak '/^## Table of Contents$/d' "${WORK_DIR}/content/specification.md"
rm "${WORK_DIR}/content/specification.md.bak"

# Generate overview from template
echo "  - Generating overview.md from template"
sed -e "s/{{VERSION}}/${VERSION}/g" \
    -e "s/{{TIMESTAMP}}/${TIMESTAMP}/g" \
    -e "s/{{COMMIT_SHA}}/${COMMIT_SHA}/g" \
    docs/publishing/overview-template.md > "${WORK_DIR}/content/overview.md"

# Generate scoring engine status from template
echo "  - Generating scoring-engine-status.md from template"
sed -e "s/{{VERSION}}/${VERSION}/g" \
    -e "s/{{TIMESTAMP}}/${TIMESTAMP}/g" \
    -e "s/{{COMMIT_SHA}}/${COMMIT_SHA}/g" \
    docs/publishing/scoring-engine-status-template.md > "${WORK_DIR}/content/scoring-engine-status.md"

# Validate output
if [ ! -s "${WORK_DIR}/content/specification.md" ]; then
    echo -e "${RED}❌ specification.md is empty${NC}"
    exit 1
fi

if [ ! -s "${WORK_DIR}/content/overview.md" ]; then
    echo -e "${RED}❌ overview.md is empty${NC}"
    exit 1
fi

if [ ! -s "${WORK_DIR}/content/scoring-engine-status.md" ]; then
    echo -e "${RED}❌ scoring-engine-status.md is empty${NC}"
    exit 1
fi

# Check for unsubstituted placeholders
if grep -q "{{VERSION}}\|{{TIMESTAMP}}\|{{COMMIT_SHA}}" "${WORK_DIR}/content/overview.md"; then
    echo -e "${RED}❌ overview.md contains unsubstituted placeholders${NC}"
    grep "{{" "${WORK_DIR}/content/overview.md" || true
    exit 1
fi

echo -e "${GREEN}✅ Content prepared successfully${NC}"
echo "  - specification.md: $(wc -l < "${WORK_DIR}/content/specification.md") lines"
echo "  - overview.md: $(wc -l < "${WORK_DIR}/content/overview.md") lines"
echo "  - scoring-engine-status.md: $(wc -l < "${WORK_DIR}/content/scoring-engine-status.md") lines"

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${YELLOW}DRY RUN MODE - Stopping before git operations${NC}"
    echo ""
    echo "Generated files available at:"
    echo "  ${WORK_DIR}/content/overview.md"
    echo "  ${WORK_DIR}/content/specification.md"
    echo "  ${WORK_DIR}/content/scoring-engine-status.md"
    echo ""
    echo "To inspect:"
    echo "  cat ${WORK_DIR}/content/overview.md | head -30"
    echo ""
    exit 0
fi

# Clone jentic-docs
echo ""
echo "Cloning jentic-docs repository..."
cd "${WORK_DIR}"
git clone --depth 1 "https://${GH_TOKEN}@github.com/jentic/jentic-docs.git" jentic-docs
cd jentic-docs

# Configure git
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

# Check if branch already exists remotely
echo ""
echo "Checking for existing branch..."
if git ls-remote --exit-code --heads origin "${BRANCH_NAME}" > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Branch ${BRANCH_NAME} already exists remotely${NC}"
    echo "   Checking out and updating existing branch..."
    git fetch origin "${BRANCH_NAME}"
    git checkout "${BRANCH_NAME}"
    git pull origin "${BRANCH_NAME}"
else
    echo "✅ Creating new branch: ${BRANCH_NAME}"
    git checkout -b "${BRANCH_NAME}"
fi

# Create target directory
echo ""
echo "Preparing target directory..."
mkdir -p docs/reference/api-readiness-framework

# Copy files
echo "Copying files..."
cp "${WORK_DIR}/content/overview.md" docs/reference/api-readiness-framework/
cp "${WORK_DIR}/content/specification.md" docs/reference/api-readiness-framework/
cp "${WORK_DIR}/content/scoring-engine-status.md" docs/reference/api-readiness-framework/

# Check for changes
echo ""
echo "🔍 Checking for changes..."
if git diff --quiet && git diff --cached --quiet; then
    echo -e "${YELLOW}⚠️  No changes detected - specification may already be up to date${NC}"
    exit 0
fi

# Show diff summary
echo ""
echo "Changes summary:"
git diff --stat

# Commit changes
echo ""
echo "Committing changes..."
git add docs/reference/api-readiness-framework/

git commit -m "docs: Update API AI-Readiness Framework specification to v${VERSION}

- Sync specification from api-ai-readiness-framework@${COMMIT_SHA:0:8}
- Updated overview and specification content

Generated by automated workflow
Source: https://github.com/jentic/api-ai-readiness-framework/commit/${COMMIT_SHA}"

# Push changes
echo ""
echo "🚀 Pushing to remote..."
git push origin "${BRANCH_NAME}"

# Create or update PR
echo ""
echo "Creating pull request..."

PR_BODY="## Summary
Automated update of the API AI-Readiness Framework specification from the source repository.

## Changes
- **Version**: ${VERSION}
- **Source Commit**: [\`${COMMIT_SHA:0:8}\`](https://github.com/jentic/api-ai-readiness-framework/commit/${COMMIT_SHA})
- **Updated**: Overview and specification content

## Review Checklist
- [ ] Specification content is accurate
- [ ] Links and references work correctly
- [ ] Navigation in MkDocs is correct
- [ ] No formatting issues
- [ ] Version metadata is correct

## Related
- Source Repository: https://github.com/jentic/api-ai-readiness-framework
- Source File: [spec.md](https://github.com/jentic/api-ai-readiness-framework/blob/main/docs/specification/spec.md)
- Automated by: [publish-spec-to-docs workflow](https://github.com/jentic/api-ai-readiness-framework/blob/main/.github/workflows/publish-spec-to-docs.yaml)"

# Check if PR already exists
export GH_TOKEN
EXISTING_PR=$(gh pr list --head "${BRANCH_NAME}" --json number --jq '.[0].number' 2>/dev/null || echo "")

if [ -n "$EXISTING_PR" ]; then
    echo "✅ PR #${EXISTING_PR} already exists - updated with new commits"
    gh pr view "${EXISTING_PR}" --web
else
    PR_URL=$(gh pr create \
        --title "Update API AI-Readiness Framework specification to v${VERSION}" \
        --body "${PR_BODY}" \
        --base main \
        --head "${BRANCH_NAME}")

    echo -e "${GREEN}✅ Pull request created successfully!${NC}"
    echo "   ${PR_URL}"
fi

echo ""
echo -e "${GREEN}🎉 Publishing complete!${NC}"
