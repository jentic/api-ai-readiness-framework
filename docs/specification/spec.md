# Jentic API AI-Readiness Framework (JAIRF) Specification

## Version 0.2.0

This document uses the key words MUST, MUST NOT, SHOULD, SHOULD NOT, and MAY as defined in [BCP 14](https://tools.ietf.org/html/bcp14) [RFC2119](https://tools.ietf.org/html/rfc2119) [RFC8174](https://tools.ietf.org/html/rfc8174) when, and only when, they appear in all capitals, as shown here.

This document is licensed under [The Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0.html).

## Introduction

The Jentic API AI-Readiness Framework (JAIRF) defines a standardized methodology for evaluating the suitability of an API for consumption by intelligent agents, LLM-driven orchestration systems, and automated integrations.
This specification defines six scored dimensions, grouped into three pillars, and a unified scoring and weighting model that produces an overall AI-Readiness Index between 0 and 100.

JAIRF is designed to evaluate an API’s ability to be:

- Interpretable — easily understood by reasoning systems
- Operable — safe and predictable to execute
- Discoverable — findable, indexable, and contextually exposed
- Governable — aligned with secure and trustworthy practices

The framework may be applied to:

- Single APIs
- Entire API portfolios
- API gateways or registries
- Design-time and runtime validation tools

JAIRF MAY be implemented as a feedback layer during API delivery, a CI/CD quality gate, a governance control, an automated readiness classifier, or as part of an AI-agent execution platform.

<!-- TOC depthFrom:1 depthTo:3 withLinks:1 updateOnSave:1 orderedList:0-->
## Table of Contents

- [Scope](#scope)
- [Terminology](#terminology)
- [Framework Architecture](#framework-architecture)
- [Dimension Model Overview](#dimensional-model-overview)
- [Dimension Definitions](#dimension-definitions)
  - [Foundational Compliance (FC)](#foundational-compliance-fc)
  - [Developer Experience & Tooling Compatibility (DXJ)](#developer-experience--tooling-compatibility-dxj)
  - [AI-Readiness & Agent Experience (ARAX)](#ai-readiness--agent-experience-arax)
  - [Agent Usability (AU)](#agent-usability-au)
  - [Security (SEC)](#security-sec)
  - [AI Discoverability (AID)](#ai-discoverability-aid)
- [Normalisation Rules](#normalisation-rules)
- [Scoring Model & Formulae](#scoring-model--formulae)
- [Appendix A: General Definitions](#appendix-a-general-definitions)

<!-- /TOC-->

## Scope

This specification defines:

- The conceptual model for API AI-readiness
- The scoring dimensions and required signals
- The weighting and aggregation model
- The readiness levels and classification thresholds
- The normative behaviours required for compliant scoring engines

This specification explicitly does not define:

- How an API provider MUST design APIs
- A proprietary scoring algorithm inaccessible to auditors
- Enforcement or certification process

JAIRF is intended to be implementation-agnostic, vendor-neutral, and API-format-agnostic, supporting (for now):

- OpenAPI 3.x
- OpenAPI 2.x

## Terminology

The following terms are used in this specification:

### API

A machine-accessible interface defined by an operational contract (e.g., OpenAPI).

### Signal

A measurable property extracted from an API (e.g., summary coverage, auth strength).
Signals are usually normalised to a value between 0 and 1. In other cases, a signal MAY be binary.

### Dimension

A thematic grouping of signals that together represent a pillar of API AI-readiness.
JAIRF defines six dimensions.

### Group

A higher-level category that bundles dimensions.

JAIRF defines three groups:

- FDX — Foundational & Developer Experience
- AIRU — AI-Readiness & Usability
- TSD — Trust / Safety / Discoverability

### Aggregation

The mathematical process of combining normalised signals into dimension scores and dimension scores into the final readiness score.

### Harmonic Mean

The weighted harmonic mean is used at the final aggregation stage to penalise imbalanced APIs where one weak dimension would otherwise be masked by strong dimensions.

### Normalisation

The method by which raw measurements (counts, ratios, textual assessments) are converted to a consistent scale.
All global normalisation rules are defined in [Normalisation Rules](#normalisation-rules).

### Readiness Level

A human-interpretable categorization mapped from the final readiness score:

| Level | Range | Interpretation |
| --- | --- | --- |
| Level 0 | `< 40` | Not Ready |
| Level 1 | `40 - 60` | Foundational |
| Level 2 | `60 - 75` | AI-Aware |
| Level 3 | `75 - 90` | AI-Ready |
| Level 4 | `> 90` | Agent-Optimized |

### Grading

A letter grade applied to each dimension and to the overall score.

## Framework Architecture

JAIRF defines a three-layer scoring architecture:

- Signals Layer (raw metrics → 0–1 scale)
- Dimension Layer (normalised signals → 0–100)
- Aggregation Layer (weighted harmonic mean → final score)

This architecture MUST be preserved by any conformant implementation.

A conformant engine MUST:

- Compute each dimension exactly as defined
- Apply weights as defined (or disclose weights)
- Use weighted harmonic aggregation
- Apply gating rules prior to final scoring
- Apply readiness classification and grading

The scoring mechanism MUST be deterministic and reproducible for any API input.

## Dimensional Model Overview

The Jentic API AI-Readiness Framework (JAIRF) evaluates an API’s maturity across six dimensions, grouped into three pillar categories. These pillars represent a staged view of maturity: beginning with structural soundness (can this be used at all), then semantic readiness (can AI understand it), and finally trust & exposure (can it be used safely and found by the right agents).

The purpose of this section is conceptual orientation. Normative definitions of each dimension appear in the [Dimension Definitions](#dimension-definitions) section.

### Pillar Categories

#### Foundational and Developer Experience (FDX)

Assesses whether an API is structurally valid, standards-compliant, and usable by humans and tooling. This establishes the prerequisite conditions for any form of automated interpretation.

Dimensions included:

- Foundational Compliance
- Developer Experience & Tooling Compatibility

#### AI-Readiness & Usability (AIRU)

 Evaluates the semantic clarity, intent expression, operational structure, and agent-operability of an API. These dimensions determine how effectively intelligent agents can interpret, plan, and execute API operations.

Dimensions included:

- AI-Readiness & Agent Experience
- Agent Usability

#### Trust, Safety, & Discoverability

Ensures that the API can be safely exposed to AI systems and that it can be effectively located, classified, and reasoned about within automated discovery environments.

Dimensions include:

- Security
- AI Discoverability

### Dimensional Structure

Each dimension represents a distinct aspect of AI readiness and MUST be evaluated independently.
The framework assumes that:

- No dimension compensates for another- a weakness in any dimension constrains overall readiness.
- Dimensions progress in logical maturity order (Foundational correctness → semantic clarity → safe exposure and discoverability).
- All dimensions score in the range [0–100], derived from normalised signals.
- The final AI-Readiness score is computed later using a weighted harmonic mean of the six dimensions.

## Dimension Definitions

This section defines normative requirements for each of the six dimensions of the Jentic API AI-Readiness Framework (JAIRF).

### Foundational Compliance (FC)

The Foundational Compliance dimension evaluates whether an API is structurally valid, standards-conformant, and parsable by modern API tooling. To do this, the presence or absence of specification-level correctness, resolution integrity, structural soundness, and linting quality, are all measured.

An API MUST NOT be considered AI-ready if it fails foundational parsing or contains severe structural defects.

#### Required Signals

| Signal | Description | Normalisation Rule |
| ---------------- | -------------------- | ---------------------------- |
| `spec_validity` | MUST indicate whether the API parses as valid OpenAPI. | [binary](#binary-checks) |
| `resolution_completeness` | MUST represent the proportion of $ref references that successfully resolve | [coverage](#coverage-normalisation) |
| `lint_results` | Aggregated quality score from linter diagnostics, weighted by severity. | inverse [weighted categorical ratio](#weighted-categorical-normalisation) |
| `structural_integrity` | MUST score schema correctness and coherence (e.g., oneOf misuse, contradictory typing, impossible constraints). | [logarithmic dampening](#logarithmic-dampening) |

#### Spec Validity (spec_validity)

```text
spec_validity = 1  # if specification parses successfully  
spec_validity = 0  # otherwise
```

#### Resolution Completeness (resolution_completeness)

```text
resolution_completeness = resolved_refs / total_refs
```

If `total_refs = 0`, the value MUST be `1.0`.

##### Example

```text
resolution_completeness = 0.92  
# (23 of 25 $ref links resolved successfully)
```

#### Lint Results (lint_results)

This signal leverages core ruleset of Spectral and Redocly, with Jentic opinions applied, as well as a Jentic custom ruleset.

```text
weighted_cost = SQRT((1.0 * critical) + (0.6 * errors) + (0.025 * warnings) + (0.005 * info))

lint_results = max(0, 1 - (weighted_cost / 25))
```

#### Structural Integrity (structural_integrity)

The _structural integrity_ signal measures whether the API's underlying data model is coherent enough for automated reasoning. Unlike linting errors — which often relate to style, documentation, or optional best practices - structural issues reflect semantic or logical defects that prevent reliable interpretation by developers, tools, and AI agents.

**Formula:**

_Structural integrity_ MUST be calculated using a logarithmic dampening curve:

```text
structural_integrity = max(0, 1 - (log10(1 + structural_issues / log10(1 + structural_issue_threshold)))
```

Where:

- `structural_issues` is the total count of structural defects detected.
- `structural_issue_threshold` represents the point where structural reliability collapses. Once an API has more than ~15 schema-breaking or integrity flaws, automated interpretation is no longer trustworthy.

The formula yields a smooth decay curve, prevents early collapse, but penalises structural issues more heavily than cosmetic issues.

A _structural issue_ MUST be recorded when any of the following occur:

| Category | Examples |
| -------- | ------------ |
| Invalid model shape | `type: object` but no `properties` defined; objects with additionalProperties: false but empty |
| Contradictory typing | `type: string` + `format: int32`; arrays using incompatible items definitions |
| Impossible constraints | `minimum > maximum`; exclusiveMinimum > exclusiveMaximum; enum values violating type, and contradictory schema constructs |
| Broken polymorphism | `oneOf`/`anyOf`/`allOf` inconsistent; missing or invalid discriminator; unreachable or contradictory sub-schemas |
| Response/request undefined | `requestBody: {}`; missing schemas; empty content definitions |
| Non-evaluable example | Examples that are invalid JSON, violate the declared schema, or contradict field constraints |
| Unresolvable or circular schema structures | Schemas that reference non-existent fields; recursive references without a valid base schema |

#### Dimension Score

```text
FC = 100 × (spec_validity + resolution_completeness + lint_results + structural_integrity) / 4
```

##### Example

```text
spec_validity: 1.0              # spec parsed successfully
resolution_completeness: 0.92   # 92% of refs resolved
lint_results: 0.85              # post-weighting
structural_integrity: 0.88      # schema irregularities

FC = 100 * (1.0 + 0.92 + 0.85 + 0.88) / 4
   ≈ 91.25
```

### Developer Experience & Tooling Compatibility (DXJ)

DXJ evaluates clarity, documentation quality, example coverage, and compatibility with Jentic’s ingestion pipeline.
An API with strong DXJ SHOULD be predictable and pleasant for both human developers and automated tooling.

#### Required Signals

| Signal | Description | Normalisation Rule |
| ---------------- | -------------------- | ---------------------------- |
| `example_density` | MUST indicate presence of examples across eligible locations. | [coverage](#coverage-normalisation) |
| `example_validity` | MUST show schema-conformance of examples. | [coverage](#coverage-normalisation) |
| `doc_clarity` | MUST quantify linguistic clarity of summaries and descriptions. | [min-max inverted](#minmax-inverted-normalisation) |
| `response_coverage` | MUST indicate presence of meaningful success and error responses. | [coverage](#coverage-normalisation) |
| `tooling_readiness` | MUST measure ingestion/bundling health within Jentic pipelines. | [inverse error](#inverse-error-normalisation) |


#### Example Density (example_density)

example_density MUST measure coverage of examples across all eligible specification locations.
It represents whether each location includes at least one example, and NOT how many examples are provided.

```text
example_density = present_examples / expected_examples
```

Where:

- each eligible location contributes one (`1`) to `expected_examples`, regardless of whether the location supports both _example_ and _examples_ fields from an OpenAPI perspective.
- multiple _examples_ defined inside an _examples_ array MUST not increase `present_examples` beyond `1`.



If `expected_examples = 0`, the value MUST be `1.0`.

#### Example Validity (example_validity)

```text
example_validity = valid_examples / total_examples
```

#### Doc Clarity (doc_clarity)

```text
doc_clarity = 1 - ((readability_score - 8) / (16 - 8))
```

Where readability_score ∈ [8, 16] (`8` is easy to read, `16` would be legaleses / hard to parse.). See `readability_score` definition in [Appendix A: General Definitions](#appendix-a-general-definitions).

#### Response Coverage (response_coverage)

```text
response_coverage = operations_with_meaningful_responses / total_operations
```

#### Tooling Readiness (tooling_readiness)

```text
tooling_readiness = max(0, 1- (ingestion_errors / 15))
```

**Tooling Readiness Threshold**
Unlike structural integrity, tooling_readiness should not be treated as a correctness gate.It reflects how much effort is required for Jentic (or a developer) to prepare the API for downstream use in our tools. For independent implementers, this threshold should reflect the gates for the relevant target tooling. `15` is chosen as an initial threshold.

| Tooling Ingestion Issues | Score | Interpretation |
| ------------------------ | ----- | -------------- |
| 0 - 3 | 0.85 - 1.0 | Easily ingested |
| 4 - 8 | 0.6 - 0.8 | Cleanup recommended |
| 9 - 14 | 0.3 - 0.5 | High friction |
| 15+ | 0.0 | Cannot reliably ingest |

#### Dimension Score

```text
DXJ = 100 × (example_density + example_validity + doc_clarity + response_c​overage + tooling_readiness) / 5
```

##### Example

```text
example_density: 0.66       # 2/3 expected example points populated
example_validity: 0.80      # valid & typed
doc_clarity: 0.75           # readable, non-legalistic
response_coverage: 0.70     # most methods cover non-2xx cases
tooling_readiness: 0.90     # imports cleanly

DXJ = 100 * (0.66 + 0.80 + 0.75 + 0.70 + 0.90) / 5
    ≈ 76.2
```

### AI-Readiness & Agent Experience (ARAX)

ARAX evaluates whether an API is semantically interpretable by AI systems—specifically whether it provides enough contextual meaning for intelligent agents to infer intent, constraints, and expected behaviors. ARAX measures semantic clarity and expressiveness, including descriptive coverage, datatype specificity, and error semantics.

#### Required Signals

| Signal | Description | Normalisation Rule |
| ----------------- | --------------------- | ----------------------------- |
| `summary_coverage` | MUST represent presence of concise summaries across specification objects with a `summary` field (e.g.,operations/tags/info etc). | [coverage](#coverage-normalisation) |
| `description_coverage` | MUST represent descriptive completeness across applicable API specification objects with a `description` field. | [coverage](#coverage-normalisation) |
| `type_specificity` | MUST quantify richness of datatype modelling. | [weighted categorical](#weighted-categorical-normalisation) |
| `policy_presence` | SHOULD represent inclusion of SLA/rate-limit/policy metadata. | [coverage](#coverage-normalisation) |
| `error_standardization` | SHOULD favour structured error formats (RFC 9457/7807). | [coverage](#coverage-normalisation) |
| `opid_quality` | MUST evaluate presence and distinctiveness of operationId values. | [composite](#composite-signal-normalisation) |
| `ai_semantic_surface` | MAY provide bonus uplift for AI-oriented metadata. | [bonus multiplier](#bonus-multipliers) |


#### Summary Coverage (summary_coverage)

```text
summary_coverage = summaries_present / summaries_expected
```

Where:

- `summaries_expected` MUST take into account every specification object with `summary` fixed field.

##### Example

```text
summary_coverage = 0.78  
 
# 78% of operations/tags/info objects etc. include a summary field
```

#### Description Coverage (description_coverage)

```text
description_coverage = described_elements / describable_elements
```

Where:

- `describable_elements` MUST take into account every specification object with a `description` fixed field.

##### Example

```text
description_coverage = 0.82 

# 82% of info objects, operations, schemas, parameters etc. include a description
```

#### Type Specificity (type_specificity)

```text
type_specificity =
(
    (1.0  × strong_types)
    + (0.75 × formatted_strings)
    + (0.50 × enum_fields)
    + (0.25 × weak_strings)
) / total_fields

```

This rewards APIs that model values semantically, not just as loosely typed strings.

#### Policy Presence (policy_presence)

```text
policy_presence = operations_with_policy_metadata / total_operations
```

This helps AI reason about risk, performance, and operational constraints.


#### Error Standardisation (error_standardisation)

```text
error_standardization = operations_using_RFC9457 / total_operations

```

This should also cater for [RFC7807](https://tools.ietf.org/html/rfc7807) which was replaced by [RFC9457](https://tools.ietf.org/html/rfc9457).

This is important for helping AI reason about failure modes, not just success paths.

#### OperationId Quality (opid_quality)

```text
coverage         = ops_with_operationId / total_operations
distinctiveness  = 1 - mean_semantic_similarity
opid_quality     = coverage × distinctiveness
```

If multiple ops appear to offer “getUser” operation, distinctiveness drops and harms AI inference.

#### AI Semantic Surface (ai_semantic_surface)

```text
ai_semantic_surface_bonus = 1 + (0.05 * ai_hint_coverage)
```

##### Example

```text
bonus = 1.015  

# 30% of operations include hints like x-intent, workflows, Arazzo links
```

#### Dimension Score

```text
core_arax = (summary_coverage + description_coverage + type_specificity + policy_presence + error_standardization + opid_quality) / 6

ARAX = 100 × core_arax × (1 + 0.05 × ai_semantic_surface)
```

##### Example

```text
summary_coverage: 0.80         # 80% described
description_coverage: 0.82     # 82% described
type_specificity: 0.76         # formats & enums used meaningfully
policy_presence: 0.40          # limited SLA/policy metadata
error_standardization: 0.50    # only half define RFC9457 (of RFC8707)
opid_quality: 0.90             # distinct & descriptive
ai_semantic_surface: 0.30      # minimal Arazzo/AI hints

core = (0.8 + 0.82 + 0.76 + 0.40 + 0.50 + 0.90) / 6 
     = 0.6966666667
bonus = 1 + (0.05 * 0.30) = 1.015

ARAX ≈ 100 * 0.6966666667 * 1.015
     ≈ 70.71

```

### Agent Usability (AU)

Agent Usability evaluates whether autonomous agents can operate the API reliably, safely, and efficiently. The dimension measures operational composability: navigation, complexity, redundancy, safety, and tool-calling alignment.

#### Required Signals

| Signal | Description | Normalisation Rule |
| ----------------- | --------------------- | ----------------------------- |
| `complexity_comfort` | Measures document size, endpoint density, and schema complexity, penalised using a logistic curve. | [logistic shaping](#logistic-shaping) |
| `distinctiveness` | MUST quantify semantic separation between operations. | inverse [semantic similarity](#semantic-similarity) |
| `pagination` | MUST represent the ration of paginated GET resources. | [coverage](#coverage-normalisation) |
| `hypermedia_support` | HATEOAS/JSON:API/HAL affordances. | [coverage](#coverage-normalisation) |
| `intent_legibility` | MUST represent verb-object semantic clarity. | [similarity](#semantic-similarity) (LLM assisted) |
| `safety` | MUST evaluate idempotency & sensitive operation protection. | [heuristic penalty](#heuristic-penalty-normalisation) |
| `tool_calling_alignment` | SHOULD represent alignment with LLM tool-calling expectations. | [coverage](#coverage-normalisation) |
| `navigation` | MUST represent pagination & hypermedia affordances. | [composite](#composite-signal-normalisation) |


#### Complexity Comfort (complexity_comfort)

```text
raw_complexity = 0.5 × normalised_endpoint_count
               + 0.5 × normalised_schema_depth

complexity_comfort = 1 / (1 + exp(6 × (raw_complexity - 0.45)))
```

##### Normalised Endpoint Count (normalised_endpoint_count)

A normalised measure of how large an API is relative to a typical operational complexity threshold.

API usability for agents degrades as endpoint count grows — but only after a certain point. A 3-endpoint API and a 12-endpoint API should not have radically different usability penalties. But a 200-endpoint platform should carry a greater complexity signal.

**Formula:**

```text
normalised_endpoint_count = min(1, total_operations / endpoint_baseline)
```

Where:

- `total_operations` is the count of unique forward-callable operations (method + path pairs). [Callbacks](https://spec.openapis.org/oas/v3.2.0.html#callback-object) and [webhooks](https://spec.openapis.org/oas/v3.2.0.html#oas-webhooks) MUST NOT be counted as endpoints.
- `endpoint_baseline` is set at `50`.



##### Normalised Schema Depth (normalised_schema_depth)

A normalised indicator of schema nesting and structure depth across all schemas.

Agent reasoning difficulty can be correlated to object depth, degree of polymorphism, and highly nested schemas.

**Formula:**

```text
normalised_schema_depth = min(1, max_schema_depth / depth_baseline)
```

Where:

- `max_schema_depth` is the deepest nesting found across all schemas
- `depth_baseline` is set at `8`.

Schemas referenced by callbacks/webhooks MUST be included in `normalised_schema_depth`, because they contribute to the overall semantic model complexity.

#### Distinctiveness (distinctiveness)

```text
distinctiveness = 1- avg_semantic_similarity
```

#### Pagination (pagination)

```text
pagination = paginated_collection_GETs / collection_GETs
```

#### Hypermedia Support (hypermedia_support)

```text
hypermedia_support = hypermedia_responses / total_navigable_responses
```

#### Navigation (navigation)

```text
navigation_readiness = (0.6 × pagination) + (0.4 × hypermedia_support)
navigation = navigation_readiness × (1 + 0.03 × links_coverage)
```

##### Example

```text
navigation = 0.443         # usable navigation with modest hint enrichment

pagination = 0.60          # 60% of eligible list endpoints are paginated

hypermedia_support = 0.20  # HAL/JSON:API/HATEOAS limited

links_bonus = 1.0075       # 25% of responses include link relations
```

#### Intent Legibility (intent_legibility)

```text
intent_legibility = mean_semantic_alignment
```

Distinctiveness is simply the _opposite_ of redundancy. if multiple endpoints do the same thing, the API becomes harder for AI to choose correctly.

For distinctiveness, operation-to-operation comparison uses embedding-based semantic similarity (cosine similarity), which captures meaning rather than string matching. Levenshtein distance MAY be used as a fallback for very small APIs (but likely not too valuable).


For `intent_legibility`, each operation is compared to a set of canonical verb-object pairs (e.g., create-resource, list-resources), ensuring that agent routing matches human-intended meaning.

#### Safety (safety)

```text
safety = ((idempotent_correctness + sensitive_ops_protected) / (2 * total_operations))
```

#### Tool Calling Alignment (tool_calling_alignment)

```text
tool_calling_alignment = operations_mappable_to_ai_tool_calls / total_operations
```

#### Dimension Score

```text
# Pagination and hypermedia combine into `navigation` (with links bound [0,1]).
navigation_readiness = 0.6 * pagination + 0.4 * hypermedia_support
navigation = navigation_readiness * (1 + 0.03 * links_coverage)

AU = 100 × (complexity_comfort + distinctiveness + navigation + intent_legibility + safety + tool_calling_alignment) / 6

```

##### Example

```text
complexity_comfort: 0.74       # logistic-shaped
distinctiveness: 0.71          # low semantic collision
pagination: 0.60               # most list GETs paginated
hypermedia_support: 0.20       # few HAL/JSON:API affordances
links_coverage: 0.25           # some link relations present
intent_legibility: 0.80
safety: 0.68
tool_calling_alignment: 0.72

navigation_readiness = (0.6 * 0.60) + (0.4 * 0.20)
                     = 0.44

links_bonus = 1 + (0.03 * 0.25) = 1.0075

navigation = 0.44 * 1.0075 ≈ 0.443

AU = 100 * (0.74 + 0.71 + 0.443 + 0.80 + 0.68 + 0.72) / 6
    ≈ 68.8
```

### Security (SEC)

Security evaluates trustworthiness, authentication strength, and operational risk posture in the context of agent-based automation.
This dimension measures authentication coverage, secret hygiene, transport security, sensitive data handling, and OWASP risk.

#### Required Signals

| Signal | Description | Normalisation Rule |
| ----------------- | --------------------- | ----------------------------- |
| `auth_coverage` | Evaluates whether authentication is correctly applied to sensitive or modifying operations, using intent-aware heuristics. | [heuristic penalty](#heuristic-penalty-normalisation) |
| `auth_strength` | MUST evaluate strength of security schemes. | [weighted categorical](#weighted-categorical-normalisation) |
| `transport_security` | MUST require HTTPS for externally exposed hosts. | [binary](#binary-checks) |
| `secret_hygiene` | MUST detect and penalise hardcoded credentials. | [binary](#binary-checks) |
| `sensitive_handling` | MUST score protection of PII/sensitive fields. | [coverage ratio](#coverage-normalisation) |
| `owasp_posture` | SHOULD reflect severity-weighted risk findings. | [severity weighted inverse](#severity-weighted-inverse) with dampening |

#### Auth Coverage (auth_coverage)

```text
auth_coverage = protected_sensitive_ops / sensitive_ops_expected
```

If `sensitive_ops_expected = 0`, then `auth_coverage` MUST be `1.0`.

##### Sensitive Operation Determination (sensitive_ops_expected)

`sensitive_ops_expected` represents the count of operations that ought to require authentication.
This value is NOT the same as “operations that declare security”, it reflects _intent-aware inference_ of security requirements.

As a guiding principle, an operation SHOULD be classified as a _sensitive operation_ if any of the following are true:

- it performs a state changing action
  - uses HTTP methods such as: `POST`, `PUT`, `PATCH`, `DELETE`
  - has summaries/descriptions which suggest state change (e.g., "approve", "update", "assign", "create", "cancel"), even if HTTP verb is misused
- it accesses or returns sensitive or personal data (customer records, user profiles, payment data, or any OpenAPI Schema Object containing detected PII fields)
- it performs privileged or administrative actions
- it exposes operational or system-level behaviours (configuration management details, system logs, workflow executions)

LLM reasoning MAY be used to help perform classification.


#### Auth Strength (auth_strength)

The auth_strength signal measures the robustness and correctness of authentication mechanisms declared by the API.
It evaluates the average strength of all security schemes using normative scores based on IANA auth-scheme definitions, OAuth2 best practices, OIDC, API Key placement, and mutual TLS.

**Formula:**

```text
# auth_strength = average_strength_of_security_schemes
auth_strength = safe_divide(sum(strength_scores), count(schemes))
```

The following table outlines the `auth_strength` scoring weights:

| Scheme Type | Description | Example | Strength | Rationale |
| ----------- | ----------- | ------- | -------- | --------- |
| `none` | No authentication mechanism | no `security:` block | `0.00` | Unsafe for sensitive APIs; permitted only when `sensitive_ops_expected = 0`. |
| `http / basic` | Base64 user:pass | `scheme: basic` | `0.10` | Plaintext credentials; easily leaked ([RFC7617](https://tools.ietf.org/html/rfc7617)). |
| `http / oauth` | OAuth 1.0 | `scheme: oauth` | `0.20` | Deprecated; insecure signature model ([RFC5849](https://tools.ietf.org/html/rfc5849)). |
| `http / digest` | Digest Access Auth | `scheme: digest` | `0.20` | Outdated; limited protection ([RFC7616](https://tools.ietf.org/html/rfc7616)). |
| `apiKey (query)` | API key in query string | `in: query` | `0.15` | Very high leakage risk (logs, proxies, URLs). |
| `apiKey (header/cookie)` | API key in header or cookie | `in: header` | `0.50` | Moderate security; lacks identity, scoping, or rotation controls. |
| `http / scram-sha-1` | SCRAM with SHA-1 | `scheme: scram-sha-1` | `0.25` | Uses deprecated SHA-1 hashing ([RFC7804](https://tools.ietf.org/html/rfc7804)). |
| `http / negotiate` | Kerberos/NTLM | `scheme: negotiate` | `0.35` | Legacy; violates HTTP semantics ([RFC4559](https://tools.ietf.org/html/rfc4559)). |
| `http / bearer (opaque)` | Opaque bearer token | `scheme: bearer` | `0.60` | Security depends entirely on token distribution ([RFC6750](https://tools.ietf.org/html/rfc6750)). |
| `http / vapid` | WebPush VAPID | `scheme: vapid` | `0.60` | Token model similar to bearer; moderate trust ([RFC8292](https://tools.ietf.org/html/rfc8292)). |
| `http / scram-sha-256` | SCRAM with SHA-256 | `scheme: scram-sha-256` | `0.65` | Modern and stronger, still password-based ([RFC7804](https://tools.ietf.org/html/rfc7804)). |
| `http / bearer (JWT)` | Signed JWT bearer token | `bearerFormat: JWT` | `0.75` | Cryptographically verifiable claims; supports scopes. |
| `http / privatetoken` | Privacy Pass | `scheme: privatetoken` | `0.75` | Strong privacy-preserving cryptographic identity ([RFC9577](https://tools.ietf.org/html/rfc9577)). |
| `http / hoba` | HTTP Origin-Bound Authentication | `scheme: hoba` | `0.80` | Asymmetric client-bound authentication ([RFC7486](https://tools.ietf.org/html/rfc7486)). |
| `http / concealed` | Concealed HTTP authentication | `scheme: concealed` | `0.85` | Modern, high-assurance privacy-preserving authentication ([RFC9729](https://tools.ietf.org/html/rfc9729)). |
| `http / dpop` | Demonstration of Proof-of-Possession | `scheme: dpop` | `0.90` | Prevents replay; binds token to client ([RFC9449](https://tools.ietf.org/html/rfc9449)). |
| `http / gnap` | GNAP framework | `scheme: gnap` | `0.90` | Modern alternative to OAuth 2.0 ([RFC9635](https://tools.ietf.org/html/rfc9635)). |
| `http / mutual` | HTTP Mutual Authentication | `scheme: mutual` | `0.95` | Cryptographically binding client/server identities ([RFC8120](https://tools.ietf.org/html/rfc8120)). |
| `oauth2 / password` | Resource Owner Password Credentials | `flow: password` | `0.30` | Deprecated; violates least-privilege; insecure. |
| `oauth2 / implicit` | Browser implicit flow | `flow: implicit` | `0.35` | Deprecated; exposes tokens via redirects. |
| `oauth2 / clientCredentials` | Server-to-server | `flow: clientCredentials` | `0.85` | Strong, scoped, recommended for machine-to-machine. |
| `oauth2 / authorizationCode (PKCE)` | Best practice auth flow | `flow: authorizationCode` | `0.90` | Most secure OAuth2 flow; protects public clients. |
| `openIdConnect` | OIDC Discovery + JWKs | `type: openIdConnect` | `1.00` | Gold-standard identity-bound access. |
| `mutualTLS` | Client TLS certificates | `type: mutualTLS` | `1.00` | Hardware-backed identity; strongest available. |


If no security schemes are defined, auth_strength MUST return `1.0` (not applicable—no schemes to evaluate).
This does not imply the API is secure; [gating rules](#gating-rules) handle misconfigurations involving sensitive operations.

#### Transport Security (transport_security)

```text
transport_security = secure_public_endpoints / public_endpoints
```

Transport security is evaluated only for endpoints intended to be externally reachable. Internal, localhost, cluster, or sandbox endpoints are excluded from the penalty. The score is based on whether externally exposed endpoints use HTTPS.

Public endpoints include:

- FQDN-based hosts (e.g., api.example.com)
- Partner-facing or customer-facing URLs
- Any endpoint not explicitly marked internal

Internal endpoints include:

- localhost / 127.0.0.*
- service mesh / `.internal` / `.cluster` hosts
- explicitly flagged `x-internal`, `dev`, `sandbox`, `mock`

#### Secret Hygiene (secret_hygiene)

```text
secret_hygiene = 1 if no secrets embedded else 0
```

#### Sensitive Handling (sensitive_handling)

```text
sensitive_handling = protected_pii_fields / detected_pii_fields
```

If no PII detected, = 1.0.

#### OWASP Posture (owasp_posture)

```text
weighted_cost = (1.0 × critical) + (0.6 × errors) + (0.025 × warnings) + (0.005 × info)
owasp_posture = max(0, 1 - (sqrt(weighted_cost) / 5))
```



#### Dimension Score

##### Base Security

```text
base_security = (auth_coverage + auth_strength + transport_security +
                 secret_hygiene + sensitive_handling + owasp_posture) / 6

```

##### Sensitivity Factor

Based on the intent of an operation / endpoint, we determine `sensitivity_factor` as:

- None/Low: 1.0
- Moderate: 0.9
- High: 0.75


##### Exposure Factor

Based on the intended audience or exposure of an endpoint, we determine `exposure_factor` as:

- internal: 1.0
- partner: 0.9
- public: 0.8


##### Scaled Security Score

```text
security_scaled = base_security × sensitivity_factor × exposure_factor

Where:
- sensitivity_factor ∈ {1.00, 0.90, 0.75}
- exposure_factor    ∈ {1.00, 0.90, 0.80}
```

##### Gating

Gating caps apply after scaling

| Condition | Cap |
| --------- | --------- |
| Hardcoded credentials | ≤ 20 |
| Sensitive op w/o auth | ≤ 40 |
| PII unprotected & non-internal | ≤ 50 |
| Public HTTP, not HTTPS | ×0.8 multiplier |

##### Security Formula

```text
SEC = 100 × Security_final
# where security_final is security_scaled after capping rules
```

###### Example

```text
auth_coverage: 0.85
auth_strength: 0.80
transport_security: 1.00     # all https
secret_hygiene: 1.00
sensitive_handling: 0.70
owasp_posture: 0.65
base_security = (0.85+0.80+1.00+1.00+0.70+0.65)/6 = 0.833
sensitivity_factor: 0.90     # moderate (profile data)
exposure_factor: 0.80        # public API
Security = 100 * 0.833 * 0.90 * 0.80
         ≈ 59.9
```

### AI Discoverability (AID)

AID evaluates how easily AI systems can locate, classify, and route to the API across registries, workflows, and knowledge bases.

The scoring framework does NOT hide unsafe APIs, but we apply a risk-aware discount so that high risk reduces discoverability rather than erasing it.

#### Required Signals

| Signal | Description | Normalisation Rule |
| ----------------- | --------------------- | ----------------------------- |
| `descriptive_richness` | MUST assess depth and clarity of descriptions. | [coverage](#coverage-normalisation) with semantic weights |
| `intent_phrasing` | MUST evaluate verb-object clarity of summaries and descriptions. | [semantic similarity](#semantic-similarity) (LLM assisted) |
| `workflow_context` | MAY include Arazzo/MCP/workflow references. | [coverage](#coverage-normalisation) |
| `registry_signals` | SHOULD detect llms.txt, APIs.json, MCP, externalDocs. | [coverage](#coverage-normalisation) (multi-indicator) |
| `domain_tagging` | SHOULD detect domain/taxonomy classification. | [coverage](#coverage-normalisation) |


#### Descriptive Richness (descriptive_richness)

The `descriptive_richness` signal evaluates the semantic value of textual descriptions within an API description. It measures whether descriptions are sufficiently clear and detailed for AI systems to infer purpose, behaviour, and domain context.

Applies to all describable elements, including but not limited to:

- `info.description`
- `info.summary`
- operation-level `summary` and `description`
- parameter, header, and response descriptions
- schema descriptions

Elements MAY be excluded if they cannot reasonably carry semantic meaning (e.g., empty marker schemas).

```text
descriptive_richness = Σ(element_descriptive_score) / (2 × number_of_describable_elements)

# Each describable element MAY earn up to 2 points (1 for clarity + 1 for depth)
```

Where:
`element_descriptive_score = clarity_score + depth_score`

The final value MUST be normalised to the range [0, 1].

##### Clarity Score

The `clarity_score` evaluates how understandable and readable a description is.

| Level                | Description                                                                       | Score   |
| -------------------- | --------------------------------------------------------------------------------- | ------- |
| **High clarity**     | Clear, direct, specific wording; purpose-first phrasing; low cognitive load       | **1.0** |
| **Moderate clarity** | Understandable but verbose, generic, or weakly phrased                            | **0.5** |
| **Low clarity**      | Boilerplate text, legalese, placeholders, or content likely to confuse AI systems | **0.0** |

Clarity MAY be evaluated using an LLM-based classifier. Flesch–Kincaid or equivalent readability indicators SHOULD be considered as supporting signals but MUST NOT be used alone.

Descriptions containing placeholder text (e.g., “foo”, “Lorem ipsum”, or obviously templated strings) MUST receive a clarity score of 0.0.

##### Depth Score

The `depth_score` evaluates the degree of semantic specificity and operational detail.
Descriptions providing actionable content SHALL receive higher depth scores.

| Level            | Description                                               | Score   |
| ---------------- | --------------------------------------------------------- | ------- |
| **High depth**   | Contains domain cues AND behavioural or structural detail | **1.0** |
| **Medium depth** | Contains domain cues but minimal behavioural detail       | **0.5** |
| **Low depth**    | Generic text without meaningful semantics or context      | **0.0** |

Depth SHOULD consider:

- domain-specific terminology (e.g., “booking segment”, “AML profile”)
- entity relationships
- state constraints and lifecycle behaviour
- when/why an operation SHOULD be called
- key field semantics or constraints

Descriptions that merely restate a field name or summary MUST be scored at 0.0.


#### Intent Phrasing (intent_phrasing)

...To be defined...

#### Workflow Context (workflow_context)

```text
workflow_context = operations_with_workflow_refs / total_operations
```

#### Registry Signals (registry_signals)

Presence of machine-readable artifacts such as:

- llms.txt
- APIs.json
- API Gateway registry metadata
- MCP registry metadata
- externalDocs link to developer portals etc.

```text
registry_signals = present_indicators / total_indicators
```

#### Domain Tagging (domain_tagging)

```text
domain_tagging = ops_with_domain_tags / total_operations
```

#### Dimension Score

```text
AID_raw = 100 × (descriptive_richness + intent_phrasing + workflow_context + registry_signals + domain_tagging) / 5
```

##### Soft Risk Discount

```text
risk_index
= exposure_weight × sensitivity_weight × (1−base_security) 

risk_discount = 1 − 0.5 × risk_index clamped to [0.6,1.0]

AID = AIDraw × risk_discount
```

##### Example

```text
descriptive_richness: 0.80
intent_phrasing: 0.75
workflow_context: 0.20
registry_signals: 0.40
domain_tagging: 0.60
AID_raw = 100 * (0.80+0.75+0.20+0.40+0.60) / 5 ≈ 55.0

Security from above gave base_security ≈ 0.833;

exposure_weight: 1.0   # public
sensitivity_weight: 0.9
risk_index = 1.0 * 0.9 * (1- 0.833) = 0.1503
risk_discount = 1- (0.5 * 0.1503) ≈ 0.9248

AID ≈ 55.0 * 0.9248 ≈ 50.8
```

## Normalisation Rules

This section defines the global normalisation functions used throughout the JAIRF framework.
All signals MUST be normalised into the range [0, 1] before dimensional aggregation.
Unless otherwise noted, higher values represent better API quality or AI-readiness.

Normalisation ensures that heterogeneous signals (e.g., counts, proportions, categorical values, text-derived scores) can be consistently aggregated within and across dimensions.

### Coverage Normalisation

Coverage is used when measuring presence versus absence of some feature (e.g., summaries, examples, pagination).

**Formula:**

```text
coverage = present / expected
```

If there are _zero expected occurrences, then:

```text
coverage = 1.0
```

This prevents false penalties where the concept is not applicable.

### Inverse Error Normalisation

Used when the presence of errors decreases quality (linting findings, structural issues, ingestion errors).

**Formula:**

```text
inverse = max(0, 1 - (issue_count / threshold))
```

Notes:

- `threshold` represents the point where the score SHOULD drop to zero. Thresholds are dimension-specific.
- Once `issue_count ≥ threshold`, the signal is floored at 0.

### Min–Max Inverted Normalisation

Applied when lower input values are better (e.g., readability burden).

**Formula:**

```text
inverted = 1 - (x - min) / (max - min)
```

- If `x ≤ min`, then `inverted = 1.0`.
- If `x ≥ max`, then `inverted = 0.0`.

### Weighted Categorical Normalisation

Used for discrete categories that map to quality levels (e.g., security scheme strength).

Each category is assigned a weight in **[0, 1]**. This allows qualitative or enumerated factors to be converted into normalized numeric values.

**Formula:**

```text
weighted = category_weight / max_weight
```

Where `max_weight` is the maximum weight in the category set.

### Composite Signal Normalisation

Used when a signal is derived from multiple measurable sub-signals (e.g., operationId quality).

**Formula:**

```text
composite = Σ(sub_score[i] × weight[i]) / Σ(weight[i])

# Example for illustration:
opid_quality = (uniqueness_ratio × 0.5 + semantic_quality × 0.5)
```

All sub-scores MUST first be individually normalised into [0, 1].

### Severity-Weighted Inverse

Applies weighted penalties for different severity levels.

**Formula:**

```text
weighted_cost =
    (1.0  × critical)
  + (0.6  × errors)
  + (0.025 × warnings)
  + (0.005 × info)

signal = max(0, 1 - (weighted_cost / max_cost))
```

Where `max_cost` is an upper bound chosen per dimension (e.g., 25 for foundational lint).

### Logarithmic Dampening

Used where a smooth decline is preferred rather than linear penalty (e.g., structural complexity).

**Formula:**

```text
log_dampened = 1 - ( logBaseN(1 + issues) / logBaseN(1 + threshold) )
```

Where:

- Base MAY be _10_ or _e_, depending on implementation preference. RECOMMENDATION is _10_ for easier understanding.
- Provides early penalty, slower collapse near threshold.

### Semantic Similarity

```text
similarity(i, j) ∈ [0, 1]
distinctiveness = 1 - similarity
```

Similarity is computed from a combination of:

- operationId
- summary
- description
- path + HTTP method
- optional LLM semantic embedding comparison

Weighted approach:

```text
similarity(i, j) =
    0.35 * embedding_similarity
  + 0.25 * opId_similarity
  + 0.20 * summary_similarity
  + 0.20 * path_similarity
```

Where similarity = cosine similarity or Levenshtein-based fallback for small APIs.

The evaluator MUST ensure:

- identical or near-identical meanings → similarity ≥ 0.85
- opposites or different purposes → similarity ≤ 0.20

### Logistic Shaping

Used to avoid over-penalising large APIs for complexity if they are well-structured.

**Formula:**

```text
logistic = 1 / (1 + exp(k × (value - midpoint)))
```

- `k` controls steepness (recommended: 5–7).
- `midpoint` defines neutrality point (recommended: ~0.4–0.5).

### Binary Checks

Used when a single violation SHOULD drop a score to zero or one.

Examples:

- hardcoded credentials
- presence/absence of HTTPS
- presence of required auth

**Formula:**

```text
binary = 1 if condition_passes else 0
```

### Bonus Multipliers

Used when optional metadata adds value especially in terms of agent usability and AI-discoverability (e.g., hypermedia links, AI intent hints, registry presence).

**Formula:**

```text
score = base_score * (1 + bonus_factor * coverage)
```

Where:

- `bonus_factor` typically ∈ [0.01, 0.10]
- `coverage` is a normalised [0, 1] value

Bonus MUST NOT push the signal above 1.0 after dimension aggregation.

### Context Scaling

Used when sensitivity or exposure magnifies or attenuates risk.

**Formula:**

```text
scaled = base_score × sensitivity_factor × exposure_factor
```

Where:

- sensitivity_factor ∈ {1.0, 0.9, 0.75}
- exposure_factor ∈ {1.0, 0.9, 0.8}

### Heuristic Penalty Normalisation

Used when qualitative rule-based deductions apply (e.g., unsafe idempotency patterns).

**Formula:**

```text
score = 1.0 - Σ(penalty[i] × severity_weight[i])
```

Clamped to **[0, 1]**.

**Example:**

```text
# Agent Usability- safety:
# An API begins with a score of 1.0, then receives deductions for risk findings:
#  Missing auth on sensitive write: −0.15
#  Non-idempotent PUT/DELETE: −0.10
#  Overlapping unsafe verbs: −0.05


safety = 1 − ( 0.15 + 0.10 + 0.05 )
```

### Soft Risk Discounts

Applied in Discoverability scoring when security posture SHOULD diminish visibility, not erase it.

**Formula:**

```text
risk_discount = 1 - (0.5 × risk_index)
```

Clamped to `[0.6, 1.0]`, to avoid total suppression.

Where:

```text
risk_index = exposure_weight × sensitivity_weight × (1 - base_security)
```

## Scoring Model & Formulae

This section NORMATIVELY defines how signals, dimensions, and the final AI-Readiness score MUST be computed.

### Scoring Pipeline

The scoring process MUST proceed in the following order:

- Raw Measurements (unbounded counts, coverage, structural errors, semantic density, etc.)
- Normalised Signals (each MUST be converted to a value ∈ [0,1])
- Dimension Scores (each MUST be computed on a 0–100 scale)
- Weighted Aggregation (weighted harmonic mean MUST be used)
- Gating Rules (MUST be applied BEFORE readiness level classification)
- Final Readiness Score (0–100)
- Readiness Level Classification

### Normalised Signals

JAIRF requires each signal to be normalised to a number on the interval [0,1].
Signal normalisation rules are defined in Appendix A, and MUST be applied consistently across all implementations.

A signal value of:

- `1.0` MUST represent optimal quality
- `0.0` MUST represent unusable, absent, contradictory, or failing input

Signals MUST NOT exceed the range [0,1] after normalisation.

### Dimension Scoring

Each dimension score MUST be the arithmetic mean of its normalised signals:

```text
DimensionScore = 100 × (Σ normalised_signals) / (count_of_signals)
```

Where:

- All signals MUST be normalised first
- All signals MUST contribute equally (v1.0 does NOT use per-signal weighting)
- Result MUST be clamped into the range [0,100]

Implementations MAY emit warnings if insufficient data is present (e.g., zero expected counts across multiple signals) but MUST NOT penalise a dimension for irrelevance.

### Dimension Weights

The JAIRF final score MUST use the following weight distribution across the six dimensions:

| Dimension | Weight |
| --------- | ------ |
| Foundational Compliance (FC) | 0.16 |
| Developer Experience & Jentic Compatibility (DXJ) | 0.18 |
| AI-Readiness & Agent Experience (ARAX) | 0.24 |
| Agent Usability (AU) | 0.20 |
| Security (SEC) | 0.12 |
| AI Discoverability (AID) | 0.10 |

These weights MUST sum to `1.0`.

### Weighted Harmonic Aggregation

JAIRF uses a weighted harmonic mean, not an arithmetic mean.
The harmonic mean MUST be used to enforce that weaknesses in one dimension CANNOT be offset by strengths in others.

Implementations MUST compute:

```text
FinalScore = (Σ weights) / (Σ (weight / (dimensionScore + epsilon)))
```

Where:

- `epsilon` MUST be a small positive constant to avoid division-by-zero. Recommended: epsilon = 0.000001
- `dimensionScore` MUST be in the range [0,100] before inclusion in the harmonic calculation
- The final score MUST also be clamped to [0,100]

The harmonic mean MUST be considered core to the JAIRF model.

### Gating Rules

Gating rules MUST override or constrain dimension scores to ensure safety and correctness.
They MUST be applied immediately before readiness-level classification.

| Condition | Effect | Rationale |
| --------- | ------ | --------- |
| Foundational Compliance score < 40 | API MUST be classified as Level 0 ("Non-Compliant") | If the API cannot be structurally validated, no higher-order AI reasoning is safe or possible. |
| Hardcoded credentials detected | Security score MUST be capped at `20` | Hardcoded secrets represent an immediate, systemic security failure and cannot be compensated for by other strengths. |
| Sensitive operations lacking auth (internal) | Security score MUST be capped at `40` | Internal APIs may permit limited trust boundaries, but unauthenticated sensitive operations remain high-risk. |
| Sensitive operations lacking auth (partner) | Security score MUST be capped at `30` | Partner-facing APIs must enforce authentication on sensitive operations; failure is a severe but not catastrophic risk. |
| Sensitive operations lacking auth (public) | Security score MUST be capped at `20` | Public unauthenticated sensitive operations are critical vulnerabilities and must be treated as near-fail conditions. |
| Unprotected PII on partner/public APIs | Security score MUST be capped at `50` | Exposure of identifiable data without proper controls violates trust and regulatory expectations. |
| Non-TLS public endpoints (http://) | Security score MUST be multiplied by `0.5` | Plaintext transport exposes tokens, credentials, and PII; catastrophic for external integrations. |


Gating MUST NOT alter the raw signals or other dimension scores directly; gating applies only to the affected dimension score.

If multiple caps apply, the most restrictive MUST be applied.

### Final Score & Readiness Levels

The final readiness score MUST be mapped to one of the following readiness levels.

| Final Score | Level   | Name                | Meaning                                               |
| ----------- | ------- | ------------------- | ----------------------------------------------------- |
| **< 40**    | Level 0 | **Not Ready**       | Fundamentally unsuitable for AI or agents             |
| **40–60**   | Level 1 | **Foundational**    | Developer-ready, partially AI-usable                  |
| **60–75**   | Level 2 | **AI-Aware**        | Semantically interpretable, safe for guided use       |
| **75–90**   | Level 3 | **AI-Ready**        | Structurally rich, semantically clear, agent-friendly |
| **90+**     | Level 4 | **Agent-Optimized** | Highly composable, predictable, automation-ready      |

This table MUST be treated as normative.
Scoring libraries MUST return both the numeric score and readiness level.

### Grading Bands

Implementations MAY additionally compute a letter grade for UX/visualisation.

| Letter Grade | Score Range |
| ------------ | ----------- |
| A+           | 90–100      |
| A            | 80–89       |
| A−           | 70–79       |
| B+           | 67–69       |
| B            | 63–66       |
| B−           | 60–62       |
| C+           | 57–59       |
| C            | 53–56       |
| C−           | 50–52       |
| D+           | 47–49       |
| D            | 43–46       |
| D−           | 40–42       |
| F            | < 40        |

Grades SHOULD NOT be used as substitutes for readiness levels.

## Appendix A: General Definitions

| Term | Description |
| ----------------- | ------------ |
| **Normalisation** | The process of converting raw measurements into a standard 0–1 scale so that different signals can be compared fairly. A normalised value of 1 represents “ideal” and 0 represents “unusable or absent.” |
| **Signal** | A measurable property inside a dimension (e.g., `auth_coverage` or `summary_coverage`). Dimensions are made of multiple signals, and each signal is normalised before aggregation. |
| **Dimension** | A thematic scoring category of API readiness (e.g., Foundational Compliance, AI-Readiness). Each dimension reflects a different aspect of what makes an API usable by AI systems. |
| **Aggregation** | The step where multiple normalised signals are mathematically combined into a single score. Aggregation happens first at the dimension level, and then across all dimensions for the final score. |
| **Harmonic Mean** | A type of average that penalises imbalanced scores. If one dimension is very weak, the harmonic mean reduces the overall score more than a standard average would. Used to ensure that no single “strong” category can mask a critical weakness in another. |
| **Clamped or Bounded** | When a value is restricted to remain within a minimum and maximum range. For example, `risk_discount ∈ [0.6, 1.0]` means it cannot go below 0.6 or above 1.0. |
| **Weighted** | A calculation where some values count more than others. Weights may allow emphasis (e.g., security > discovery). |
| **Logistic Shaping** | A smoothing technique that stops large APIs from being unfairly penalised simply because they have many endpoints. It scales penalties gradually rather than linearly. |
| **Coverage** | The percentage of “where this should exist” versus “where it actually exists.” For example: `auth_coverage = operations_with_auth / ops_that_require_auth`. |
| **Penalty** | A downward adjustment applied when a risk or deficiency is identified (e.g., missing pagination, weak auth, or unsafe error handling). |
| **Bonus (or Uplift)** | A small upward modifier applied when extra AI-friendly metadata is present (e.g., workflows, AI intent hints). |
| **Readability Score** | A measure of how easy text is to understand, based on approximate grade-level complexity (e.g., Flesch–Kincaid). Lower scores indicate simpler, more direct language. APIs targeting AI consumption benefit from 8–12 range; >16 introduces interpretation risk for models.<br><br>**≤ 8th grade:** universally readable<br>**9–12:** general technical audience (expected for API docs)<br>**> 16:** post-grad, cognitively expensive, increases model misinterpretation risk.<br><br>This score is determined by the LLM evaluating the `readability_score`. |
