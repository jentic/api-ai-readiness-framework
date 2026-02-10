# Jentic API AI-Readiness Framework

**Current Version**: {{VERSION}}
**Last Updated**: {{TIMESTAMP}}

[View Full Specification](specification.md){ .md-button .md-button--primary }

## What is the API AI-Readiness Framework?

The Jentic API AI-Readiness Framework provides a standardized methodology for evaluating how well an API supports consumption by AI agents, LLMs, and automated systems.

Most APIs today are designed for human developers. They rely on documentation, implicit conventions, and tribal knowledge. AI agents need something different: **machine-readable semantics, predictable structures, and explicit operational contracts**.

This framework defines **six scored dimensions** that measure an API's ability to be:

- **Interpretable** — easily understood by reasoning systems
- **Operable** — safe and predictable to execute
- **Discoverable** — findable, indexable, and contextually exposed
- **Governable** — aligned with secure and trustworthy practices

The scoring model produces an overall AI-Readiness Index between **0 and 100**, mapped to five readiness levels that guide improvement efforts.

## The Six Dimensions

The framework evaluates APIs across six dimensions, grouped into three pillars:

### Foundational & Developer Experience (FDX)

**1. Foundational Compliance (FC)**
Structural validity, standards-conformance, and parsability. Can modern API tooling reliably interpret this specification?

**2. Developer Experience & Tooling Compatibility (DXJ)**
Documentation clarity, example coverage, response completeness, and ingestion health. Is this API pleasant and predictable for humans and tools?

### AI-Readiness & Usability (AIRU)

**3. AI-Readiness & Agent Experience (ARAX)**
Semantic clarity, intent expression, datatype specificity, and error standardization. Can AI systems infer purpose and constraints?

**4. Agent Usability (AU)**
Operational composability, complexity comfort, navigation affordances, and safety patterns. Can agents operate this API reliably and efficiently?

### Trust, Safety, & Discoverability (TSD)

**5. Security (SEC)**
Authentication strength, transport security, secret hygiene, and OWASP risk posture. Can this API be safely exposed to AI systems?

**6. AI Discoverability (AID)**
Descriptive richness, intent phrasing, workflow context, and registry signals. Can AI systems locate and classify this API?

## Readiness Levels

The final AI-Readiness score maps to one of five levels:

| Level | Score Range | Name | Meaning |
| ----- | ----------- | ---- | ------- |
| **Level 0** | < 40 | **Not Ready** | Fundamentally unsuitable for AI or agents |
| **Level 1** | 40–60 | **Foundational** | Developer-ready, partially AI-usable |
| **Level 2** | 60–75 | **AI-Aware** | Semantically interpretable, safe for guided use |
| **Level 3** | 75–90 | **AI-Ready** | Structurally rich, semantically clear, agent-friendly |
| **Level 4** | 90+ | **Agent-Optimized** | Highly composable, predictable, automation-ready |

## When to Use This Framework

Apply this framework when you need to:

- **Validate API designs** for AI-readiness during development
- **Assess existing APIs** for compatibility with LLM-driven systems
- **Establish governance controls** with measurable quality gates
- **Improve discoverability** for AI agents searching API catalogs
- **Benchmark API portfolios** across enterprise or ecosystem-wide collections
- **Guide modernization** efforts with prioritized, actionable recommendations

The framework works with OpenAPI 3.x and 2.x specifications. It's implementation-agnostic, vendor-neutral, and designed for both design-time validation and runtime assessment.

## How It Works

1. **Signal Extraction** — Measurable properties are extracted from the API specification (e.g., authentication coverage, example density, operation complexity)
2. **Normalization** — Raw measurements are converted to a 0–1 scale using defined normalization rules
3. **Dimension Scoring** — Normalized signals are aggregated into six dimension scores (0–100)
4. **Weighted Harmonic Aggregation** — Dimension scores are combined using a weighted harmonic mean to prevent weak dimensions from being masked by strong ones
5. **Gating Rules** — Safety constraints (e.g., hardcoded credentials, missing auth on sensitive operations) cap scores where appropriate
6. **Readiness Classification** — The final score is mapped to a readiness level with actionable guidance

## Key Principles

**Validity ≠ Usability**: A syntactically valid OpenAPI specification doesn't guarantee an API is interpretable by AI systems. This framework measures **semantic clarity and operational safety**, not just schema correctness.

**Harmonic Penalization**: The scoring model uses a weighted harmonic mean rather than arithmetic averaging. Weak dimensions pull down the overall score more aggressively, ensuring balanced improvement across all areas.

**Context-Aware Security**: Security scores are adjusted based on API sensitivity (low/moderate/high) and exposure (internal/partner/public). A public API with sensitive operations faces stricter requirements than an internal API.

**No Silver Bullets**: There's no single fix that makes an API AI-ready. The framework identifies **prioritized improvements** across structural, semantic, operational, and security domains.

## Related Resources

- **[Full Specification](specification.md)** — Complete technical specification with normative requirements
- **[Jentic Public APIs](https://github.com/jentic/jentic-public-apis)** — Collection of scored API specifications demonstrating the framework in practice
- **Blog Posts**:
  - [Why Most APIs Fail in AI Systems and How to Fix It](https://thenewstack.io/why-most-apis-fail-in-ai-systems-and-how-to-fix-it/) (The New Stack)
  - [Is Your OpenAPI AI-Ready?](https://jentic.com/blog/is-your-open-api-ai-ready) (Jentic)
  - [Scoring APIs for AI](https://jentic.com/blog/scoring-apis-for-ai) (Jentic)

## Specification Metadata

- **Version**: {{VERSION}}
- **Last Published**: {{TIMESTAMP}}
- **License**: [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0.html)

---

**Questions or feedback?** Reach out to the [Jentic team](https://jentic.com).
