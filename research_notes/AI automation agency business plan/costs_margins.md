# Cost Structure, Profit Margins & Tech Stack of an AI Automation Agency (US, as of Sept 2026)

All prices were retrieved on 2026-09-27 unless noted. Where a vendor page was blocked or only third-party sources were available, this is flagged. Per-client run-cost figures are **estimates built from cited unit prices**; the usage assumptions are stated.

## Q1. Current pricing for core tools, LLM APIs and voice, and per-client monthly run cost

### Takeaway
Tool and inference costs are small compared with labor. A typical text chatbot costs roughly $5–$60/month per client in LLM tokens, and a simple workflow automation costs $25–$100/month. The exception is voice: all-in voice AI runs about $0.09–$0.15 per minute, so a client using 1,000 minutes a month costs about $90–$150, and voice costs grow in step with call volume. Two items hit hardest at small scale: fixed platform minimums (Vapi Pro $999/month; Vapi HIPAA $2,000/month; Supabase Team $599/month) and GoHighLevel's $97–$497/month agency plans.

### Cited Findings

**Workflow and automation platforms**
- n8n Cloud: Starter €20/month (billed annually) for 2,500 executions; Pro €50/month for 10,000 executions. The Business plan (€667/month, 40,000 executions) is self-hosted. Enterprise is custom. All plans include unlimited users, workflows and integrations. Billing is per full workflow execution, not per step. Annual billing gives 17% off. Concurrency is 5, 20 and 200+ by tier. The page shows EUR and has no date. — [n8n pricing](https://n8n.io/pricing/)
- n8n USD equivalents reported by third parties: Starter about $24/month, Pro about $60/month. Treat these as secondary figures. — [Goodspeed / search aggregation](https://goodspeed.studio/blog/n8n-pricing); [InstaPods](https://instapods.com/blog/n8n-pricing/)
- The n8n Community Edition is free to self-host (on GitHub, about 206k stars). The only cost is hosting. — [n8n pricing](https://n8n.io/pricing/)
- Make.com: Core about $10.59/month (10,000 operations), Pro about $18.82/month, Teams about $34.12/month, all billed annually. Monthly billing adds about 20%. These are **third-party figures**; I did not verify them on make.com. — [AISaaSToolkit](https://aisaastoolkit.com/blog/make-com-pricing); [pxlpeak](https://pxlpeak.com/blog/ai-tools/make-pricing-guide)
- Zapier: Free (100 tasks); Professional $19.99/month annual or $29.99/month monthly (750 tasks); Team $69/month. These are **third-party figures**. — [Toolradar](https://toolradar.com/blog/zapier-pricing-2026); [SmartProcessFlow](https://smartprocessflow.com/zapier-pricing)
- Airtable: Free (1,000 records per base); Team $20/seat/month; Business $45/seat/month; Enterprise Scale custom. These are **third-party figures**. — [TinyCommand](https://tinycommand.com/blogs/airtable-pricing-explained); [Noloco](https://noloco.io/blog/airtable-pricing)
- Supabase: Free $0 (500 MB DB, 2 active projects, paused after 1 week inactive). Pro $25/month (100k MAU, 8 GB disk/project, 250 GB egress, 100 GB storage). Team $599/month (SOC 2 and ISO 27001; HIPAA available as a paid add-on at an undisclosed price). Enterprise custom. — [Supabase pricing](https://supabase.com/pricing)
- GoHighLevel: Starter $97/month (3 sub-accounts); Unlimited $297/month (unlimited sub-accounts, rebilling); Agency Pro $497/month (SaaS mode). AI Employee add-on: $50/month per sub-account (Growth) or $97/month (Unlimited). — [HighLevel pricing](https://www.gohighlevel.com/pricing)

**Voice AI (per minute)**
- Vapi: $0.05/min platform fee on usage-only. Providers are passed through at cost:
  - Transcription (Deepgram): $0.0095–$0.0099/min
  - LLM (OpenAI): $0.0077–$0.0452/min
  - Voice (ElevenLabs): $0.0146–$0.0238/min
  - Telephony (Twilio, Vonage or Telnyx): $0.008–$0.0143/min

  Plans:
  - Usage-only: $0, 4 concurrent calls
  - Core: $29/month, 10 concurrent calls
  - Pro: $999/month minimum, 30 concurrent calls

  Extra concurrent line $10/month. **HIPAA add-on $2,000/month.** — [Vapi pricing](https://vapi.ai/pricing)
- Retell AI: voice engine $0.055/min.
  - TTS: $0.015/min (in-house, Cartesia, OpenAI, etc.) up to $0.040/min (ElevenLabs)
  - LLM: GPT-5 nano $0.0016/min; Claude 4.5 Sonnet $0.08/min; premium models up to $0.32/min
  - Telephony: $0.015/min, or free with your own SIP trunk

  Retell quotes about $0.11/min for a baseline setup. Pay-as-you-go includes 20 concurrent calls; extra concurrency is $8 per slot per month. — [Retell pricing](https://www.retellai.com/pricing)
- ElevenLabs Agents ("Speech Engine"): $0.08/min for extra minutes on every plan. Included minutes range from 15 (Starter) to 12,375 (Enterprise). TTS API: $0.10 per 1K characters (v3/v2 Multilingual) or $0.05 per 1K characters (Flash/Turbo/v3 Conversational). — [ElevenLabs API pricing](https://elevenlabs.io/pricing/api)
- Twilio US voice:
  - Outbound local/toll-free: $0.0140/min
  - Inbound local: $0.0085/min
  - Inbound toll-free: $0.0220/min
  - Local number: $1.15/month; toll-free number: $2.15/month
  - Recording: $0.0025/min; ConversationRelay: $0.07/min

  — [Twilio US voice pricing](https://www.twilio.com/en-us/voice/pricing/us)

**LLM API token prices (USD per million tokens, input/output)**
- **Anthropic:**
  - Claude Haiku 4.5: $1 / $5 (cheapest current model)
  - Claude Sonnet 5: $2 / $10. This started as introductory pricing and is now the standard price; the planned rise to $3/$15 was cancelled.
  - Sonnet 4.6: $3 / $15
  - Claude Opus 5.5: $4 / $20
  - Opus 5: $5 / $25
  - Claude Fable 5.1 (top tier): $10 / $50

  The Batch API is 50% off. Cache reads cost 0.1× the input price (0.05× on Opus 5.5). US-only inference costs 1.1×. **Claude 4.7 and later models use a new tokenizer that produces about 30% more tokens for the same text**, which raises the effective cost per word. Anthropic's own worked example: about $37 per 10,000 support tickets on Haiku 4.5 at about 3,700 tokens per conversation. — [Anthropic pricing docs](https://platform.claude.com/docs/en/about-claude/pricing)
- **OpenAI:**
  - Flagship: gpt-5.5 $5 / $30; gpt-5.6-sol $4 / $20
  - Mid-tier: gpt-5.6-terra $2 / $12; gpt-5.4 $2.50 / $15
  - Cheap: gpt-5.6-luna $0.20 / $1.20; gpt-5.4-mini $0.75 / $4.50; gpt-5-mini $0.25 / $2.00; gpt-5-nano $0.05 / $0.40
  - Realtime voice: gpt-realtime-2.1 audio $32 in / $64 out; realtime-2.1-mini audio $10 / $20

  I fetched these from developers.openai.com because openai.com/api/pricing returned 403. — [OpenAI API pricing](https://developers.openai.com/api/docs/pricing)
- **Google Gemini (paid tier):**
  - Gemini 3.8 / 3.7 Flash: $0.75 / $3.75 until Dec 31, 2026. **This doubles to $1.50 / $7.50 on Jan 1, 2027.**
  - Gemini 3.5 Flash: $1.50 / $9.00
  - Gemini 3.5 Flash-Lite: $0.30 / $2.50
  - Gemini 3.1 Flash-Lite: $0.25 / $1.50 (cheapest)

  Batch and Flex are about 50% off. — [Gemini API pricing](https://ai.google.dev/gemini-api/docs/pricing)

### Inferences (ESTIMATES: modeled from the unit prices above, assumptions stated)
- **Text chatbot** (2,000 conversations/month; about 6k input and 800 output tokens each, cumulative over turns = 12M input and 1.6M output tokens):
  - Haiku 4.5: about $20/month
  - Sonnet 5: about $40/month (before the roughly 30% tokenizer uplift, so closer to $50)
  - gpt-5-mini: about $6/month
  - Gemini 3.1 Flash-Lite: about $5/month

  Add hosting and DB: Supabase Pro $25/month (or free tier) plus a share of n8n (about $0–$60). **All-in run cost is about $30–$130/month per client.**
- **Voice agent** (1,000 inbound minutes/month):
  - Retell baseline: about $110
  - Vapi stack (0.05 + ~0.0095 + 0.008–0.045 + 0.015–0.024 + 0.008–0.014 per min): about $90–$145
  - ElevenLabs Agents: about $80 plus telephony (about $8.50 on Twilio inbound local)
  - Plus $1.15/month per number

  **All-in about $90–$160/month per 1,000 minutes.** Cost grows linearly with minutes: 5,000 minutes is about $450–$800/month. Choosing a premium LLM can double the per-minute cost.
- **Workflow automation** (5,000 runs/month, some with an LLM step at about 2k input and 300 output tokens):
  - n8n Pro about $60 (or about €20 Starter if volume fits)
  - LLM on Haiku about $17.50; on Flash-Lite about $4

  **About $25–$100/month per client.** Self-hosting n8n Community Edition on one shared VPS for several clients could cut platform cost toward zero per client, but adds DevOps labor. VPS price not researched; see Gaps.
- If the agency resells at a typical $1,000–$5,000/month retainer (see Q4), direct tool and inference COGS is about 2–15% of revenue for chatbots and workflows. For high-volume voice it can reach 20–40%.
- **Price-trend risk:** the Gemini Flash price doubles on Jan 1, 2027, and Anthropic's new tokenizer adds about 30% more tokens per text. Model in a 20–100% buffer on inference line items.

### Gaps
- I could not verify Make, Zapier and Airtable prices on the vendors' own pages; the figures above come from 2026 third-party guides. Make has been moving to credits-based billing, so re-check make.com.
- The Gemini Pro-tier (flagship) price was not shown in the fetched extract.
- The price of Supabase's HIPAA add-on is not published.
- VPS/hosting costs for self-hosted n8n were not researched.
- I found no current official number for Vapi's pass-through "total per minute".

## Q2. Benchmark margins: agencies, professional services, MSPs, AI-native companies, and SaaS

### Takeaway
Service businesses keep about 35–60% of revenue after direct costs (gross or project margin) and about 10–20% as net profit (EBITDA or after-tax). Small studios do best, at about 19% net. SaaS aims for 75%+ gross margin. AI-heavy software companies land at about 25–60% gross margin because inference is a direct cost of every sale.

### Cited Findings
- **Promethean Research (digital agencies):**
  - Average after-tax net margin: 13% in 2025, 14% in 2024; long-run average about 15%
  - By size: studios (0–9 FTE) 19%; 10–24 FTE 12%; 25–49 FTE 9%; 50+ FTE 8%
  - Average project margin: 35% among agencies that track it (37% if engagement sizes are growing, 30% if shrinking)
  - Average agency revenue: $4.43M

  — [Promethean Research: How Profitable Are Digital Agencies](https://prometheanresearch.com/how-profitable-are-digital-agencies/)
- **Net margin by agency type (Promethean, via search summary):** design 18%, marketing and blended 13%, development 11%. — [Promethean 2026 State of Digital Services](https://prometheanresearch.com/2026-state-of-digital-services-digital-agency-industry-research/) (search snippet, not fully fetched)
- **Agency gross-margin targets:** Parakeeto (agency finance advisors) suggests 50–60%+ agency-wide and 70%+ on individual projects. This is a secondary citation. — [Relay / aggregated](https://relayfi.com/blog/marketing-agency-profit-margin/); [Swydo](https://www.swydo.com/blog/agency-profitability/)
- **SPI Research 2026 Professional Services Maturity Benchmark** (509 firms, 245k+ employees, 2025 data):
  - EBITDA: 9.9% (five-year average 13.8%)
  - Billable utilization: 66.4%, an all-time low. The healthy minimum is 70%; high performers reach 75%+.
  - Project margin: 37.7%, a five-year high (high-performer T&M 45.1%)
  - Revenue per consultant: about $210k
  - AI: 27.1% of projects use generative AI. Firms applying AI widely report 17.9% EBITDA versus 6.0% for non-adopters.

  — [Rocketlane summary of SPI 2026](https://www.rocketlane.com/blogs/professional-services-maturity-index-2026). The prior-year SPI 2025 report cited 9.8% EBITDA and about 68.9% utilization. — [SPI Research 2025](https://spiresearch.com/2025/02/12/the-18th-annual-professional-services-maturity-benchmark-report-is-out-now/). The utilization figures differ between sources and years (68.9% vs 66.4%).
- **MSPs (Service Leadership Index, via secondary sources):**
  - Average gross margin: about 52% in 2025 (48% in 2022)
  - Average EBITDA: about 18.4% (14.7% in 2022)
  - Top performers: 18–20% EBITDA; mid-tier 9–11%; bottom quartile below 5%
  - Project-services gross margin fell from 23% (Q4 2023) to 12.9% (Q4 2024) because of low project utilization

  — [ConnectWise/Service Leadership press release](https://www.connectwise.com/company/press/releases/service-leadership-index-q4-data); [MedhaCloud stats](https://medhacloud.com/blog/managed-services-market-statistics-2026) (secondary; the specific 52% and 18.4% figures are aggregator-reported)
- **AI startups (Bessemer):**
  - State of AI 2025: fast-scaling "Supernovas" average about 25% gross margin; steadier "Shooting Stars" about 60%. Both are below the 75%+ SaaS norm.
  - State of the Cloud 2024: vertical-AI portfolio companies averaged about 65% gross margin, with model costs about 10% of revenue.

  These come via secondary summaries. — [Tanay Jaipuria](https://www.tanayj.com/p/the-gross-margin-debate-in-ai); [Jeff Brokaw](https://jeffbrokaw.com/blog/ai-gross-margins/); [SaaSMag](https://www.saasmag.com/ai-cogs-saas-gross-margin-compression/)

### Inferences
- A realistic target for a two-person AI automation shop: **50–70% gross margin** on retainers (labor plus tools as direct costs) and **15–25% net** once the founders pay themselves market salaries. This is plausible because small studios lead net margins (19%) and tool COGS is small.
- Pure-SaaS margins (75–80%) are only reachable if the offering becomes productized and self-serve. Voice-heavy offerings behave like AI SaaS (25–60% gross) unless per-minute pricing is marked up at least 2–3×.
- Price retainers so that tool and inference pass-through is billed at cost-plus or capped. Otherwise heavy-usage clients compress margin.

### Gaps
- The AMI (Agency Management Institute) benchmark numbers were not retrieved.
- I found no primary a16z or The Information figures on AI-startup gross margins in this pass; Bessemer figures are via secondary summaries.
- I found no published benchmark specific to "AI automation agencies". Those numbers exist only in blog and anecdote form (see Q4).

## Q3. Fixed startup costs: legal entity, insurance, compliance, accounting

### Takeaway
Most fixed costs are modest: $50–$500 to form the LLC, $0–$800/year in state fees, and about $1,000–$2,500/year of insurance. The exceptions are California's $800/year franchise tax and healthcare work, where HIPAA-grade vendor tiers add thousands per month.

### Cited Findings
- **LLC formation:** filing fees are $50–$500 depending on state. The average annual LLC fee is about $91. California charges an $800 minimum franchise tax every year. Delaware's LLC tax is $400 for 2026. Wyoming's minimum annual fee is about $60 (one source says $52). — [LLC University](https://www.llcuniversity.com/llc-annual-fees-by-state/); [StartBusinessByState](https://startbusinessbystate.com/llc-cost-by-state/)
- **Insurance (Insureon averages for IT consultants):**
  - Tech E&O (errors and omissions bundled with cyber): about $75/month ($899/year)
  - Standalone cyber: about $128/month ($1,540/year)
  - General liability: about $31/month
  - General consultants: professional liability about $62/month; cyber about $81/month

  — [Insureon IT consultant costs](https://www.insureon.com/technology-business-insurance/it-consultants/cost); [Insureon consulting costs](https://www.insureon.com/consulting-business-insurance/cost)
- **HIPAA infrastructure costs:**
  - Vapi HIPAA add-on: $2,000/month — [Vapi](https://vapi.ai/pricing)
  - Supabase HIPAA: requires the Team plan ($599/month) plus a paid add-on — [Supabase](https://supabase.com/pricing)
- **SOC 2 posture:** Supabase includes SOC 2 and ISO 27001 only on the Team plan ($599/month). — [Supabase](https://supabase.com/pricing)

### Inferences (ESTIMATES)
- Year-1 fixed baseline for two people outside California (excluding salaries):
  - LLC: about $100–$300
  - Tech E&O plus general liability: about $1,300/year
  - Registered agent and bookkeeping software: unsourced, estimate a few hundred dollars
  - Contract templates or attorney review: unsourced

  **Estimated total: about $2k–$5k/year.**
- Healthcare clients: add at least $2.6k/month (Vapi HIPAA plus Supabase Team) before any BAA legal review. **Price healthcare work at a premium, or avoid it early on.**

### Gaps
- No cited data on costs for attorney-drafted MSA/SOW templates, CPA or bookkeeping fees, GDPR/CCPA compliance tooling, or Hiscox/Next quotes (only Insureon averages were retrieved).
- I did not confirm whether each LLM vendor offers a BAA or charges for one. Anthropic's pricing page does not mention BAAs.

## Q4. Labor economics: build hours, utilization, contractors

### Takeaway
Labor is the dominant cost. Builds take about 20–60 hours and sell for about $3k–$15k; retainers run about $1k–$5k/month and need about 3–4 hours per client per month. Professional-services firms bill only about 66–75% of their time, so a two-person team has about 2,400–2,800 billable hours per year between them.

### Cited Findings
- Typical builds take 20–60 hours and are priced at $3k–$15k. Single-workflow builds run $1.5k–$7.5k; multi-system builds (CRM, calendar and phone) run $8k–$25k. — Blog aggregations (lower-quality sources): [LearnForge](https://learnforge.dev/blog/n8n-automation-agency/); [Layer3Labs](https://www.layer3labs.io/roi/ai-automation-agency-cost); [thecrunch.io](https://thecrunch.io/ai-automation-agency-cost/)
- Retainers run $1k–$5k/month (some sources say $2.5k–$8k). n8n retainers run $1.2k–$8k/month. An example: 10 clients at $1.5k/month each = $15k MRR, needing about 3–4 hours per client per month of maintenance. — [BULDRR](https://buldrr.com/n8n-automation-agency-pricing/); [Bet on AI rate card, 54 operators](https://betonai.net/ai-automation-rate-card-2026-what-to-charge-for-n8n-make-and-zapier-builds-real-rates-from-54-operators/) (blog-grade)
- SPI benchmarks: billable utilization is 66.4% industry-wide against a 75%+ high-performer benchmark. Revenue per consultant is about $210k. — [Rocketlane/SPI 2026](https://www.rocketlane.com/blogs/professional-services-maturity-index-2026)

### Inferences (ESTIMATES)
- Two founders × 2,000 hours × 60–70% utilization = about 2,400–2,800 billable hours per year. At an effective $100–$150/hour, that is roughly $240k–$420k revenue capacity before hiring. This fits SPI's revenue per consultant of about $210k.
- Retainer economics: 3–4 hours per client per month at $1.5k/month is about $375–$500/hour of effective retainer yield. **Retainers are where the margin is.** One-off builds are bounded by hours.

### Gaps
- No reliable source was found for 2026 US contractor rates for n8n/Make/voice-AI freelancers (for example, Upwork medians). Scaling-cost assumptions for contractors remain unsourced.

## Q5. Risks to margin: vendor price changes, API dependency, maintenance burden

### Takeaway
The biggest margin risks are usage-based inference and voice costs, upstream price changes, and maintenance that is underpriced when clients pay per project. There are concrete 2026–27 price-change examples, and practitioners report that unmaintained AI systems usually break within months.

### Cited Findings
- **Scheduled price increase:** Gemini 3.7/3.8 Flash doubles from $0.75/$3.75 to $1.50/$7.50 per million tokens on Jan 1, 2027. — [Gemini pricing](https://ai.google.dev/gemini-api/docs/pricing)
- **Price changes can go either way:** Anthropic cancelled a planned Sonnet 5 increase to $3/$15 and kept $2/$10. However, Claude 4.7+ models use a tokenizer producing about 30% more tokens per text. — [Anthropic pricing](https://platform.claude.com/docs/en/about-claude/pricing)
- **Model deprecations:** Claude Opus 4/4.1, Sonnet 4 and Haiku 3.5 are retired on the first-party API. Builds pinned to old models must be migrated. — [Anthropic pricing](https://platform.claude.com/docs/en/about-claude/pricing)
- **Maintenance burden:** "AI systems drift. Prompts degrade, APIs change, phone carriers update requirements… A handed-over system with nobody maintaining it usually breaks within months." Per these sources, this is why project-only pricing is losing ground to managed retainers. — [search-aggregated agency guides](https://www.layer3labs.io/roi/ai-automation-agency-cost) (blog-grade)
- **Low utilization erodes profit:** MSP project-services gross margin fell from 23% to 12.9% in a year because of low project-team utilization. — [ConnectWise / Service Leadership](https://www.connectwise.com/company/press/releases/service-leadership-index-q4-data)
- **Scale-tier cliffs:** Vapi jumps from $29 to a $999/month minimum for 30 concurrent calls. Supabase jumps from $25 to $599 for SOC 2/HIPAA. — [Vapi](https://vapi.ai/pricing); [Supabase](https://supabase.com/pricing)

### Inferences
- Mitigations:
  - Pass through usage costs, or bill them at cost-plus
  - Price voice per minute, with a markup
  - Keep a model-agnostic LLM layer so you can switch vendors when prices change
  - Include maintenance in a mandatory retainer
  - Keep a 20–30% buffer on inference cost lines
- Concentration on one platform (for example, all clients on GoHighLevel or all voice on Vapi) creates both pricing and platform-policy risk.

### Gaps
- No quantitative data was found on how often automations break or how many maintenance hours they need, beyond practitioner anecdotes.
