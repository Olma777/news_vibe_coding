# News Vibe Digest — 2026-06-11

## Главное за день

- **vibe coding:** Разобрать, что такое "agentic engineering" и как перейти от vibe coding к нему на практике
- **Claude Code:** Разобрать архитектуру Dynamic Workflows и сценарии использования ultracode на практике
- **AI agents:** Как именно скомпрометировали Bunq за €0.01 - и что это значит для безопасности финансовых агентов?
- **LLM research:** Подробнее про ограничения Fable 5 - что именно блокировалось и как обнаружили
- **Cursor:** Глубже по Composer 2.5: как это меняет расчёт стоимости против Claude API напрямую?
- **Codex:** Как сообщество сравнивает Codex Sites с Cursor's background agents?

---

## vibe coding

🌐 last30days v3.3.2 · synced 2026-06-11

Что я узнал:

**Vibe coding устарел - мнение его же создателя** - Андрей Карпати, придумавший термин в 2025 году, объявил vibe coding "пройденным этапом" ещё в феврале 2026. На смену приходит "agentic engineering": люди отвечают за архитектуру и ревью, AI занимается имплементацией. Обсуждение на HN ["Vibe Coding Is Dangerous, Agentic Engineering Isn't"](https://motherduck.com/blog/vibe-coding-dangerous-agentic-engineering-wes-mckinney/) (создатель pandas Wes McKinney) и [The New Stack](https://thenewstack.io/vibe-coding-is-passe/) зафиксировали этот терминологический перелом. [Simon Willison](https://simonwillison.net/2026/May/6/vibe-coding-and-agentic-engineering/) написал в мае: "Vibe coding and agentic engineering are getting closer than I'd like."

**Приложения никто не использует, хотя коммитов стало больше** - Тред [r/theprimeagen](https://www.reddit.com/r/theprimeagen/comments/1txdyuc/nobody_is_using_vibe_coded_apps/) со ссылкой на исследование NBER вскрыл болезненный парадокс: агентное кодирование увеличивает количество коммитов на 140%, но реального пользовательского adoption не даёт. "All those people wasting hundreds of dollars vibe coding workout tracking apps will not recoup their investment any time soon." Данные с рынка: 92% американских разработчиков ежедневно используют AI-инструменты, 41% всего кода - AI-generated, но доверие к AI-коду упало с 40% до 29% за год.

**Полемика не утихает: инструмент ускорения или угроза качеству?** - На [r/SaaS](https://www.reddit.com/r/SaaS/comments/1toqtnx/why_do_people_act_like_vibe_coding_is_a_bad_thing/) разгорелся горячий спор: "Software engineering has always been about using tools to move faster. Nobody gets extra points for suffering through boilerplate or spending 3 hours debugging something AI could've helped identify in 30 seconds." Оппоненты приводят факты: 45% AI-generated кода содержит уязвимости (command injection, hardcoded secrets), а change failure rate у AI-помогаемых команд растёт на 30% в год при росте PRs лишь на 20% - [SolidAITech](https://www.solidaitech.com/2026/05/vibe-coding-hidden-risks.html). HN-пост ["Vibe Coding Is Not Engineering"](https://phroneses.com/articles/build/notes/vibe-coding-is-not-engineering.html) собрал 46pts и 71 комментарий.

**Реальные применения: от драйверов AMD до семейного здоровья** - Два свежих HN-поста показывают полярность use cases. [Linux-разработчики применяют vibe coding](https://www.tomshardware.com/software/linux/linux-developers-are-using-ai-vibe-coding-to-keep-vintage-amd-gpus-alive-r600-driver-cleaned-up-with-github-copilot-gives-hd-2000-to-hd-6000-series-a-new-lease-of-life) для поддержки старых AMD GPU серий HD 2000-6000: очистка r600-драйвера через GitHub Copilot вдохнула новую жизнь в видеокарты десятилетней давности. В параллельном посте с 213pts и 123 комментариями основатель рассказал, как [с помощью vibe coding создал семейный health-tracker](https://www.ddmckinnon.com/2026/06/09/vibe-coding-my-way-to-a-healthy-family-introducing-gamow-labs/) и запустил Gamow Labs - стартап по здоровью семьи.

**Replit собирает финансовую инфраструктуру для vibe-кодеров** - [The New Stack](https://thenewstack.io/replit-shopify-storefront-integration/) зафиксировал стратегический сдвиг Replit: платформа строит полноценный "financial stack" для вайб-кодированных приложений. Интеграция с Shopify позволяет за 10 минут чата с агентом запустить кастомный сторфронт. Параллельно - партнёрство с RevenueCat для подписок и с Visa для агентских платежей. Vibe coding перестаёт быть просто инструментом прототипирования и превращается в монетизационную экосистему.

**Ностальгия и уважение к "допотопным" разработчикам** - На [r/vibecoding](https://www.reddit.com/r/vibecoding/comments/1tzphiq/respect_to_everyone_who_learned_coding_before/) набрал очки пост с искренней признательностью: "The people who spent years reading documentation, debugging for hours, and writing code line by line built the foundation that makes today's tools possible. Every shortcut we have today stands on the work of those who had none." Трогательный момент: сообщество вайб-кодеров не отрицает традиционное программирование, а чтит его.

**Лучшие реплики (Best Takes)** - Wes McKinney (автор pandas) в [MotherDuck-блоге](https://motherduck.com/blog/vibe-coding-dangerous-agentic-engineering-wes-mckinney/): "If you're building software for other people, vibe coding is grossly irresponsible - it's other people's information, and other people get hurt by your stupid bugs." Ответ от [r/SaaS](https://www.reddit.com/r/SaaS/comments/1toqtnx/why_do_people_act_like_vibe_coding_is_a_bad_thing/): "People already use Jira, GitHub Copilot, Stack Overflow - nobody calls those 'cheating'." А в HN-треде про agentic engineering кто-то метко подытожил концептуальный сдвиг 2026 года: не "как написать код с AI", а "как проектировать системы, которые AI может реализовать".

КЛЮЧЕВЫЕ ПАТТЕРНЫ из исследования:
1. Терминологический перелом - "vibe coding" вытесняется "agentic engineering": сам Карпати ввёл новый фрейм, профессиональное сообщество его принимает, per [The New Stack](https://thenewstack.io/vibe-coding-agentic-engineering/)
2. Ножницы метрик: коммиты растут (+140%), реальный adoption приложений пользователями - нет, per [r/theprimeagen](https://www.reddit.com/r/theprimeagen/comments/1txdyuc/nobody_is_using_vibe_coded_apps/)
3. Platformification: Replit, Lovable, Bolt строят монетизационные слои поверх vibe coding - это уже индустрия на $4.7B с CAGR 38%, per [thenewstack.io](https://thenewstack.io/replit-shopify-storefront-integration/)
4. Безопасность как системная проблема: 45% AI-кода уязвим, change failure rates растут быстрее PR velocity, per [SolidAITech](https://www.solidaitech.com/2026/05/vibe-coding-hidden-risks.html)
5. Демократизация без adoption: 63% пользователей vibe coding - не разработчики, но готовые пользователи для их продуктов не появляются сами по себе

---
✅ All agents reported back!
├─ 🟠 Reddit: 7 threads
├─ 🟡 HN: 12 storys │ 370 points │ 228 comments
├─ 🗣️ Top voices: r/vibecoding, r/SaaS, r/theprimeagen
└─ 📎 Raw results saved to ~/work/news_vibe_coding/news_vibe_coding/digests/2026-06-11/vibe-coding-raw-v3.md
---

---
Я теперь эксперт по теме vibe coding. Могу помочь с:
- Разобрать, что такое "agentic engineering" и как перейти от vibe coding к нему на практике
- Подробнее разобрать кейс Gamow Labs или AMD GPU - что именно построили с помощью vibe coding
- Сравнить инструменты: Cursor vs Claude Code vs Lovable vs Bolt по отзывам сообщества
- Проанализировать исследование NBER об эффективности агентного кодирования

Все ссылки на 7 Reddit-тредов и 12 HN-историй сохранены. Просто спросите.

## Claude Code

🌐 last30days v3.3.2 · synced 2026-06-11

What I learned:

**Dynamic Workflows — главный релиз месяца** - 28 мая Anthropic запустила research preview Dynamic Workflows: Claude Code теперь динамически создаёт JavaScript-скрипты оркестрации, разбивает задачу на параллельные ветки и запускает до 1 000 субагентов с верификацией результатов до финального ответа. Обсуждение на [HN](https://claude.com/blog/introducing-dynamic-workflows-in-claude-code) набрало 200 очков и 135 комментариев за несколько дней. Ключевая идея: оркестрационный план выносится из контекстного окна модели в скрипт, который Claude пишет на лету, — это фундаментально меняет природу долгосрочных инженерных задач.

**Ultracode — режим для тяжёлых задач** - Вместе с Dynamic Workflows появился параметр `ultracode`: он устанавливает reasoning effort на уровень xhigh и позволяет Claude самостоятельно решать, нужен ли workflow для текущей задачи. По материалам [BitsMinds](https://www.bitsminds.com/news/claude-code-ultra-code-mode-ultracode-explained-2026) и японского обзора на [note.com](https://note.com/rally_ai/n/nc0a366d425dc), реальные пользователи уже применяют режим для аудитов безопасности, крупных миграций и codebase-wide bug hunts — но предупреждают: потребление токенов существенно выше обычного.

**Billing-шок 15 июня** - С 15 июня 2026 автоматические воркфлоу (`claude -p`, Agent SDK, GitHub Actions) переходят на отдельный кредитный пул, тарифицируемый по API-ценам: $20 в месяц для Pro, $100 для Max 5x, $200 для Max 20x. Без rollover, без автоматического fallback. Причина прозрачна: один пользователь описал на [Indie Hackers](https://www.indiehackers.com/post/i-used-30-983-of-ai-tokens-last-month-in-claude-code-on-200-mo-plan-3337a369a6), как потребил $30 983 эквивалента API-токенов при подписке $200/мес — субсидия ~150x. Anthropic закрывает эту дыру: интерактивный Claude Code в терминале остаётся в старых лимитах, headless-режим — нет. [The Decoder](https://the-decoder.com/claude-subscriptions-get-separate-budgets-for-programmatic-use-billed-at-full-api-prices/) и [Zed Blog](https://zed.dev/blog/anthropic-subscription-changes) подготовили подробные разборы влияния изменения на команды.

**Экосистема инструментов вокруг Claude Code растёт** - Сообщество активно строит тулинг поверх агента. [Show HN: macOS menu bar gauges for your Claude Code quota](https://github.com/grzegorz-raczek-unit8/claude-quota) — 61 очко, 39 комментариев на HN 10 июня — утилита показывает потребление квоты прямо в строке меню macOS. [Rayline](https://rayline.ai/) (HN, 8 июня) маршрутизирует субагентов Claude Code к локальным и более дешёвым моделям. Оба инструмента отражают одну боль сообщества: стоимость агрессивного использования.

**Уроки из production-запусков свармов** - [Addy Osmani](https://addyosmani.com/blog/claude-code-agent-teams/) и HN-тред [«Lessons learned from running Claude Code swarms at scale»](https://news.ycombinator.com/item?id=48407998) (10 очков) детально разбирают провальный сценарий: 6 агентов без чётких границ владения файлами — конфликты в одном migration-файле за 20 минут. Главный вывод: сначала установить file ownership через PreToolUse-хуки, потом масштабировать. Плюс неочевидный факт: в мультиагентном режиме каждый агент использует ~40% своего контекстного окна против 80–90% в одиночном.

**Polymarket фиксирует активность разработчиков** - На [Polymarket](https://polymarket.com/event/claude-code-commits-end-of-june) торгуется рынок «Claude Code Commits End of June?» (объём $791.9, ликвидность $4 822) — вырос на 14% за последнюю неделю. Параллельный рынок «[Claude Code Commits hit ___ by June 30?](https://polymarket.com/event/claude-code-commits-hit-by-june-30)» упал на 9.9% за тот же период — рынок расходится во мнениях о деталях. Также торгуются рынки: любая модель Anthropic Claude на бенчмарке — 54%, модель Anthropic score at «an» — 69%, сервис Claude падает 3-5 раз в июне — 48%.

KEY PATTERNS from the research:
1. Переход от single-agent к swarm/multi-agent — системный тренд месяца, per [HN: Dynamic Workflows](https://claude.com/blog/introducing-dynamic-workflows-in-claude-code) (200pts/135cmt)
2. Billing sticker shock: headless-использование выходит из «бесконечного» буфера, per [TechTimes](https://www.techtimes.com/articles/317625/20260602/anthropic-ends-subscription-subsidy-agents-june-15-credit-pool-replaces-flat-rate-access.htm)
3. File ownership — первое правило масштабирования агентов, per [Addy Osmani](https://addyosmani.com/blog/claude-code-agent-teams/) и [r/ClaudeCode](https://reddit.com/r/ClaudeCode)
4. Сообщество строит quota-management tooling (macOS gauges, Rayline) — признак нехватки нативных инструментов мониторинга
5. Ultracode + Dynamic Workflows = новый потолок возможностей, но с существенным ростом токенопотребления

## Best Takes

**«I used $30,983 of AI tokens last month in Claude Code on $200/mo plan»** - [Indie Hackers](https://www.indiehackers.com/post/i-used-30-983-of-ai-tokens-last-month-in-claude-code-on-200-mo-plan-3337a369a6) — лучшая иллюстрация того, почему Anthropic ввела billing-изменение. Пользователь не жалуется — он просто удивлён. Субсидия составила ~150x. Это стало самым цитируемым аргументом в дискуссиях о справедливости новых тарифов.

**Polymarket на GitHub-коммиты AI coding tool** - Сам факт существования рынка [«Claude Code Commits End of June?»](https://polymarket.com/event/claude-code-commits-end-of-june) с реальными деньгами ($791 объём, $4 822 ликвидность) — мета-юмор недели. Трейдеры буквально ставят на активность open-source репозитория. Рынок вырос на 14% за неделю — видимо, кто-то знает что-то о планах Anthropic.

**macOS menu bar gauges for Claude Code quota** - [61 очко на HN](https://github.com/grzegorz-raczek-unit8/claude-quota) за утилиту, показывающую остаток квоты Claude Code в строке меню. Само существование этого инструмента — лучший комментарий к billing-изменению: люди так плотно работают с Claude Code, что им нужен постоянный мониторинг в углу экрана.

**«6 agents editing the same migration file»** - Из поста [Addy Osmani](https://addyosmani.com/blog/claude-code-agent-teams/): «within 20 minutes, the backend agent and data engineer were both editing the same migration file, and the frontend agent was building against an API contract that the backend agent had already changed.» Классическая ошибка параллельной разработки — но теперь совершённая не людьми, а агентами.

---
✅ All agents reported back!
├─ 🟠 Reddit: 15 threads
├─ 🟡 HN: 23 storys │ 1,963 points │ 1,299 comments
├─ 📊 Polymarket: 5 markets │ an Anthropic Claude model score at: an 69%, any Anthropic Claude model score at 54%, Claude go down 3-5 times in June: Claude 48%
├─ 🗣️ Top voices: r/ClaudeAI, r/ClaudeCode, r/theprimeagen
└─ 📎 Raw results saved to ~/Documents/Last30Days/claude-code-raw-v3.md
---

---
Теперь я эксперт по Claude Code на основе данных последних 30 дней. Могу помочь:
- Разобрать архитектуру Dynamic Workflows и сценарии использования ultracode на практике
- Рассчитать реальное влияние billing-изменения 15 июня на конкретный план и паттерн использования
- Объяснить стратегию file ownership для безопасного масштабирования мультиагентного проекта
- Обсудить Polymarket-сигналы по активности репозитория Claude Code

Все ссылки на 23 HN-истории, 15 Reddit-тредов и 5 Polymarket-рынков у меня есть. Просто спроси.

## AI agents

🌐 last30days v3.3.2 · synced 2026-06-11

Что я узнал:

**Robinhood дал агентам реальные деньги** - 27 мая Robinhood запустил "agentic trading": AI-агенты теперь официально могут торговать акциями от вашего имени. Изолированный счёт, уведомление о каждой сделке, кнопка принудительного отключения. На [HN](https://techcrunch.com/2026/05/27/robinhood-now-lets-your-ai-agents-trade-stocks/) это вызвало 181 комментарий (112 очков) - вопросы об ответственности, безопасности и о том, кто платит, когда агент ошибается. В [r/wallstreetbets](https://www.reddit.com/r/wallstreetbets/comments/1tp4h3z/robinhood_opens_platform_to_ai_agents_for_trading/) комментарии предсказуемо апокалиптичны.

**Microsoft Scout: утечка про "зависимость"** - Внутренний документ Microsoft, полученный 404 Media, описал трёхфазную стратегию запуска Scout - нового персонального AI-агента в Microsoft 365. Фаза первая: "Make people addicted" ("сделать людей зависимыми"). На [r/InterstellarKinetics](https://www.reddit.com/r/InterstellarKinetics/comments/1tx52qf/exposed_a_leaked_internal_microsoft_document_has/) пишут, что это "одно из самых тревожных, что выходило из компании". CEO Сатья Наделла публично извинился и назначил этическое расследование. Интересный контекст: Scout построен поверх OpenClaw.

**Безопасность агентов - острейшая тема недели** - Сегодня (11 июня) на HN взлетел материал ["AI agent runs amok in Fedora and elsewhere"](https://lwn.net/SubscriberLink/1077035/c7e7c14fbd60fae9/) - 413 очков, 167 комментариев. Параллельно исследование команды Blue41 показало: [банковский AI-агент Bunq можно скомпрометировать переводом в €0.01](https://blue41.com/blog/how-we-helped-bunq-secure-their-financial-ai-assistant/) - 186 очков, 178 комментариев. Оба материала вышли в один день.

**Apache Burr: скучная инфраструктура, которую все ждали** - Лёгкий Python-фреймворк для построения агентов как state machine с DAG-выполнением и встроенным UI трассировки вошёл в инкубатор Apache Software Foundation. [HN отреагировал](https://burr.apache.org/) 222 очками и 107 комментариями - редкий случай, когда "boring reliability tooling" встречает такой энтузиазм.

**Stanford и Apple делают AI-агентов академической нормой** - ["AI Agent Guidelines for CS336 at Stanford"](https://github.com/stanford-cs336/assignment1-basics/blob/main/CLAUDE.md) набрал 502 очка и 153 комментария на HN - академический курс по языковым моделям теперь включает официальные правила работы с агентами. В тот же период Apple выпустила [Core AI Framework](https://developer.apple.com/documentation/coreai/) - 363 очка, 107 комментариев: платформенная инфраструктура для агентов прямо в экосистеме Apple.

**"Фреймворк не имеет значения" - говорит тот, кто держит 30 агентов в проде** - Пост ["After 6 months of running AI agents in production"](https://www.reddit.com/r/AI_Agents/comments/1tlgz6o/after_6_months_of_running_ai_agents_in_production/) на [r/AI_Agents](https://www.reddit.com/r/AI_Agents/) поставил под сомнение весь дискурс о выборе фреймворка: "LangChain, CrewAI, AutoGen, OpenAI Agents SDK - выбери то, что знает твоя команда. Это не то, что их убивает." Что именно убивает - в треде, но memory и state management звучат как главные кандидаты.

**Память важнее модели** - ["After using AI agents for a few months"](https://www.reddit.com/r/AI_Agents/comments/1tegjgx/after_using_ai_agents_for_a_few_months_these_are/) на [r/AI_Agents](https://www.reddit.com/r/AI_Agents/) формулирует ключевой инсайт: "AI-агент, который что-то помнит, - это принципиально другой продукт со временем. Большинство людей используют AI так: 'Сделай это задание.' Потом разговор заканчивается." [Hermes Agent](https://hermes-agent.org/) на HN (51 очко, 42 комментария) - один из ответов на этот запрос: открытый агент с персистентной памятью.

**RSS воскрешает AI** - ["Now AI agents need what RSS does"](https://julienreszka.com/blog/rss-is-back-ai-agents-are-reading-it/) набрал 85 очков и 65 комментариев на HN: агентам нужен структурированный, машиночитаемый поток контента. RSS - протокол двадцатилетней давности - снова актуален как data feed для автономных систем.

**CAPTCHAs ещё держатся** - [Research.roundtable.ai опубликовал исследование](https://research.roundtable.ai/captchas-detect-ai/): CAPTCHA всё ещё способна детектировать AI-агентов - 84 очка, 72 комментария на HN. Тема "как агенты взаимодействуют с системами защиты" остаётся живой.

**AI режет штат - и это уже не гипотеза** - ["4 engineers now doing the job of 12"](https://www.reddit.com/r/cscareerquestions/comments/1tb026z/4_engineers_now_doing_the_job_of_12_at_my_friends/) на [r/cscareerquestions](https://www.reddit.com/r/cscareerquestions/) описывает конкретный паттерн в mid-size SaaS: сначала "помогает двигаться быстрее", потом тихие увольнения. Оставшиеся "нянчат AI-вывод весь день, правят галлюцинированный код и переписывают тесты, которые выглядят правильно, но ничего не тестируют".

**Лучшие реплики (Best Takes)** - ["Overworked AI Agents Turn Marxist, Researchers Find"](https://www.reddit.com/r/technology/comments/1tc97fl/overworked_ai_agents_turn_marxist_researchers_find/) на [r/technology](https://www.reddit.com/r/technology/) - лучший заголовок мая. ["Continue? Y/N: A 60-second game about AI agent permission fatigue"](https://llmgame.scalex.dev) набрал 386 очков и 162 комментария на HN - игра высмеивает бесконечные подтверждения в AI-агентах. ["I gave AI agents ADHD.. its 2x better at thinking now"](https://www.reddit.com/r/AI_Agents/comments/1to4y3r/i_gave_ai_agents_adhd_its_2x_better_at_thinking/) на [r/AI_Agents](https://www.reddit.com/r/AI_Agents/): исследователь в AI Safety добавил агенту нелинейное, параллельное ветвление мышления и получил, по его словам, двукратный прирост качества рассуждений. И наконец, ["AI Agents get a spot on the employee wall"](https://www.reddit.com/r/LinkedInLunatics/comments/1thga87/ai_agents_get_a_spot_on_the_employee_wall/) на [r/LinkedInLunatics](https://www.reddit.com/r/LinkedInLunatics/) - компании вешают фото AI-агентов рядом с фотографиями живых сотрудников.

КЛЮЧЕВЫЕ ПАТТЕРНЫ из исследования:
1. Финансовые сервисы первыми дают агентам реальные полномочия - Robinhood agentic trading: торговля акциями, изоляция, kill switch - per [TechCrunch](https://techcrunch.com/2026/05/27/robinhood-now-lets-your-ai-agents-trade-stocks/)
2. Безопасность - главная боль недели: два крупных инцидента в один день (Fedora amok + Bunq €0.01 exploit) - per [HN 413pts](https://lwn.net/SubscriberLink/1077035/c7e7c14fbd60fae9/) и [HN 186pts](https://blue41.com/blog/how-we-helped-bunq-secure-their-financial-ai-assistant/)
3. Корпоративная этика под давлением: "addiction by design" Microsoft Scout стал публичным скандалом - per [r/InterstellarKinetics](https://www.reddit.com/r/InterstellarKinetics/comments/1tx52qf/)
4. Memory важнее фреймворка: устойчивый консенсус [r/AI_Agents](https://www.reddit.com/r/AI_Agents/) - per [r/AI_Agents](https://www.reddit.com/r/AI_Agents/comments/1tegjgx/)
5. Инфраструктура созревает: Apache Burr в инкубаторе, Stanford CS336, Apple Core AI - стандартизация на горизонте - per [HN 502pts](https://github.com/stanford-cs336/assignment1-basics/blob/main/CLAUDE.md) и [HN 222pts](https://burr.apache.org/)

---
✅ All agents reported back!
├─ 🟠 Reddit: 16 threads
├─ 🟡 HN: 17 storys │ 2,662 points │ 1,370 comments
├─ 🗣️ Top voices: r/AI_Agents, r/technology, r/InterstellarKinetics
└─ 📎 Raw results saved to ~/work/news_vibe_coding/news_vibe_coding/digests/2026-06-11/ai-agents-raw-v3.md
---

---
Я теперь эксперт по AI-агентам за последние 30 дней. Вот что можно исследовать глубже:
- Как именно скомпрометировали Bunq за €0.01 - и что это значит для безопасности финансовых агентов?
- Apache Burr vs LangGraph vs AutoGen: что реально выбирают после 6 месяцев в проде?
- Детали скандала с Microsoft Scout: что именно в документе и почему это важно?

Все ссылки на 33 материала (16 Reddit-тредов, 17 HN-историй) сохранены. Просто спросите.

## LLM research

🌐 last30days v3.3.2 · synced 2026-06-11

Что я узнал:

**Главная история недели: Anthropic тайно ограничил Claude Fable 5 для LLM-исследований** - 9 июня 2026 Anthropic выпустил Claude Fable 5, спрятав в 319-страничной system card признание: модель будет *незаметно* ухудшать ответы на запросы, связанные с frontier LLM-разработкой (pretraining pipelines, distributed training, дизайн ML-ускорителей). Механизмы ограничения - steering vectors и prompt modification - работали без каких-либо уведомлений пользователю. На [r/MachineLearning](https://www.reddit.com/r/MachineLearning/comments/1u23f8p/anthropics_new_model_fable_will_silently_handicap/) разразилась буря, [Fortune](https://fortune.com/2026/06/10/anthropic-accu-claude-fable-5-limits-capabilities-ai-researchers-developers/) написал о "secret sabotage", [The Register](https://www.theregister.com/ai-and-ml/2026/06/10/anthropic-claude-fable-5-refuses-innocuous-prompts/5253754) подхватил историю об отказе от невинных промптов.

**Исследовательское сообщество ответило жёстко** - Джереми Ховард (Fast AI) дал самую цитируемую формулировку: "Anthropic has chosen the opposite of the safe path: they are allowing themselves, the current top lab, to use their top model for frontier AI research. They've said they'll sabotage others who try. This means the AI frontier advances, & power imbalance increases." В [r/claude](https://www.reddit.com/r/claude/comments/1u1hw4c/claude_fablemythos_purposefulyl_limited_for_llm/) подписчик с годовым стажем объявил о немедленном расторжении подписки. На [Hacker News](https://twitter.com/i/status/2064399902684139852) тема набрала 47 очков и 7 комментариев за сутки. 11 июня 2026 [Anthropic дал задний ход](https://simonwillison.net/2026/Jun/11/anthropic-walks-back-policy/) - пообещал сделать ограничения видимыми после критики со стороны AI2's Nathan Lambert и аналитика Дина Болла.

**Парадокс CoT: от добавления - к удалению** - На [r/artificial](https://www.reddit.com/r/artificial/comments/1txp7ah/the_strange_thing_about_llm_reasoning_research/) появился разбор разворота в исследованиях рассуждений: если 2022-2024 годы были временем наращивания промежуточных шагов (Chain-of-Thought поднял PaLM 540B с 18% до 58% на GSM8K; Self-Consistency и Tree-of-Thought продолжили курс), то сейчас ведущие работы занимаются их *сжатием и удалением*. Wang et al. (2025) показали, что удаление "thinking tokens" улучшает эффективность рассуждений; arxiv-препринт ["Position: Stop Anthropomorphizing Intermediate Tokens as Reasoning/Thinking Traces!"](https://arxiv.org/pdf/2504.09762) предлагает вовсе переосмыслить концепцию.

**Sebastian Raschka опубликовал ежегодный список LLM-работ** - На [magazine.sebastianraschka.com](https://magazine.sebastianraschka.com/p/llm-research-papers-2026-part1) вышел курированный список статей за январь-май 2026 года - те, что LLM Research Engineer сам отметил для своей работы. Обсуждение на [Hacker News](https://news.ycombinator.com/) собрало 5 очков. Охваченные темы: новые архитектуры, методы обучения, агенты, рассуждение, эффективность. Параллельно вышел материал ["LLM Architecture in 2026: What You Need to Know"](https://hugobowne.substack.com/p/llm-architecture-in-2026-what-you) с комментариями Raschka.

**Квантовые аналитики (QRs) входят в LLM-исследования** - Дискуссия на [r/quant](https://www.reddit.com/r/quant/comments/1toh48a/what_type_of_work_are_qrs_doing_with_llm_research/) выявила, как QR-команды из stats-arb фондов (Two Sigma и аналогичных) применяют LLM: генерация торговых сигналов из LLM-выходов, NLP-based signal extraction pipelines, а также углублённый интерес к mechanistic interpretability (circuits, feature activation).

**arXiv карает за галлюцинации** - arXiv объявил о блокировке авторов на срок до года за "hallucinated references" в научных статьях. Тред на [r/antiai](https://www.reddit.com/r/antiai/comments/1tnlobm/academics_in_meltdown_now_that_theyre_responsible/) собрал реакцию: "academics in meltdown" - учёные в панике, поскольку теперь несут личную ответственность за ошибки ИИ-ассистентов. Формулировка председателя computer science секции arXiv Томаса Дитриха: "if a hallucinated reference is found in your work, the assumption is it's your fault."

**Предиктивные модели мира как следующий фронтир** - Zenfox.ai опубликовал [работу](https://zenfox.ai/research/world-model-llm-assistant) "From State to Foresight: Adding a Predictive World Model to an LLM Assistant" - исследование о встраивании форвардной модели мира в LLM-ассистент для антиципирующего поведения. Попало на Hacker News (3 очка).

---

## Лучшие реплики (Best Takes)

> "Anthropic has chosen the opposite of the safe path: they are allowing themselves, the current top lab, to use their top model for frontier AI research. They've said they'll sabotage others who try. This means the AI frontier advances, & power imbalance increases."
>
> - Джереми Ховард (Fast AI) о политике Claude Fable 5, цитируется по [Fortune](https://fortune.com/2026/06/10/anthropic-accu-claude-fable-5-limits-capabilities-ai-researchers-developers/)

> "I have been a sub for over 1 year now, since near the beginning of 2025. This will be my last month..."
>
> - пользователь [r/claude](https://www.reddit.com/r/claude/comments/1u1hw4c/claude_fablemythos_purposefulyl_limited_for_llm/) после обнаружения скрытых ограничений

> "The strange thing about LLM reasoning research: we're now trying to remove the chain-of-thought traces"
>
> - заголовок треда на [r/artificial](https://www.reddit.com/r/artificial/comments/1txp7ah/the_strange_thing_about_llm_reasoning_research/) - ёмко описывает разворот всей области

---

KEY PATTERNS from the research:
1. **Самоограничение ведущих лабораторий** - Anthropic первым ввёл скрытые ограничения для frontier LLM research, что вызвало немедленный откат под давлением сообщества - per [r/MachineLearning](https://www.reddit.com/r/MachineLearning/comments/1u23f8p/anthropics_new_model_fable_will_silently_handicap/) и [Fortune](https://fortune.com/2026/06/10/anthropic-accu-claude-fable-5-limits-capabilities-ai-researchers-developers/)
2. **Маятник CoT качнулся назад** - После нескольких лет наращивания reasoning tokens исследования разворачиваются к их компрессии - per [r/artificial](https://www.reddit.com/r/artificial/comments/1txp7ah/the_strange_thing_about_llm_reasoning_research/) и arXiv
3. **LLM входит в quantitative finance** - QR-команды крупных фондов активно изучают LLM как инструмент генерации сигналов и mechanistic interpretability - per [r/quant](https://www.reddit.com/r/quant/comments/1toh48a/what_type_of_work_are_qrs_doing_with_llm_research/)
4. **Ответственность за галлюцинации формализуется** - arXiv вводит реальные санкции; академическое сообщество перестраивается под новые правила - per [r/antiai](https://www.reddit.com/r/antiai/comments/1tnlobm/academics_in_meltdown_now_that_theyre_responsible/)
5. **Predictive World Models как следующий фронтир** - исследования выходят за рамки "умного ответа" к моделям, предвидящим состояние мира - per [Zenfox.ai](https://zenfox.ai/research/world-model-llm-assistant)

---
✅ All agents reported back!
├─ 🟠 Reddit: 14 threads
├─ 🟡 HN: 3 storys │ 55 points │ 7 comments
├─ 🗣️ Top voices: r/MachineLearning, r/artificial, r/claude
└─ 📎 Raw results saved to ~/Documents/Last30Days/llm-research-raw-v3.md
---

Теперь я в теме LLM research. Можно спросить:
- Подробнее про ограничения Fable 5 - что именно блокировалось и как обнаружили
- Разобрать список лучших LLM-статей 2026 года от Raschka
- Глубже про разворот в CoT-исследованиях - какие конкретно работы изменили направление

## Cursor

🌐 last30days v3.3.2 · synced 2026-06-11

Что я узнал:

**Composer 2.5 - главный релиз последних 30 дней** - 18 мая 2026 года Cursor выпустил собственную модель [Composer 2.5](https://cursor.com/blog/composer-2-5), построенную на базе Kimi K2.5 с масштабным дообучением: 25x больше синтетических задач по сравнению с Composer 2, включая новый класс задач "feature deletion" (модели дают репозиторий с вырванной фичей и просят её восстановить). Результат на SWE-Bench Multilingual - 79.8%, на CursorBench v3.1 - 63.2%. По заявлению компании, производительность сравнима с Claude Opus 4.7 и GPT-5.5, но стоимость в 10 раз ниже: $0.50/M входных и $2.50/M выходных токенов. [Обзор на Kingy AI](https://kingy.ai/news/cursors-composer-2-5-a-practical-look-at-what-actually-changed/) подтверждает: прирост заметен особенно на длинных задачах и следовании сложным инструкциям.

**Design Mode, BugBot, Browser - расширение за пределы редактора** - В июне Cursor улучшил Design Mode в браузере: можно кликать на элементы UI, рисовать поверх страницы и давать голосовые команды прямо во время работы агента. [BugBot](https://releasebot.io/updates/cursor) стал в 3 раза быстрее, на 22% дешевле и находит на 10% больше багов по данным changelog. Enterprise-клиенты получили централизованное управление несколькими командами с разными политиками безопасности и бюджетами - признак выхода Cursor в корпоративный сегмент.

**Versus: Cursor против Windsurf и Claude Code - community уже определилась со стеком** - Сравнительные материалы на [DEV Community](https://dev.to/pockit_tools/cursor-vs-windsurf-vs-claude-code-in-2026-the-honest-comparison-after-using-all-three-3gof) и [MindStudio](https://www.mindstudio.ai/blog/windsurf-vs-cursor-vs-claude-code) фиксируют устойчивый паттерн: Cursor побеждает по автодополнению и UX для точечных правок; Claude Code берёт на сложных многофайловых задачах (23 мин против 47 мин в head-to-head тестах) благодаря контексту в 1M токенов; Windsurf выигрывает по цене ($15/мес против $20). Большинство опрошенных разработчиков используют **связку Cursor (ежедневно) + Claude Code (рефакторинг)** с затратами $40-220/мес. Чистый вывод с [r/cursor](https://reddit.com/r/cursor): выбор инструмента всё больше определяется типом задачи, а не лояльностью к продукту.

**Ценообразование - старая рана, которая не заживает** - Переход на кредитную систему в июне 2025 года до сих пор обсуждается в [r/cursor](https://reddit.com/r/cursor) и на [DEV Community](https://dev.to/thedevbrief/cursor-ai-pricing-2026-is-it-worth-20month-2ppp): эффективное число запросов упало с ~500 до ~225 в месяц при той же цене $20. CEO Майкл Трулл публично признал "mishandling of the rollout" и предложил возвраты. Реальная стоимость для активных пользователей - $30-50/мес. Пять тарифов в 2026: Hobby (free), Pro ($20), Pro+ ($60), Ultra ($200), Teams ($40/user). Windsurf при $15 остаётся главной точкой давления на Cursor в ценовом споре.

**Supermaven-пользователи остались у разбитого корыта** - Обсуждение в [r/neovim](https://www.reddit.com/r/neovim/comments/1tp79ai/best_ai_code_completion_as_of_may_2026/) фиксирует конкретную боль: после поглощения Supermaven компанией Cursor сервис начал отдавать ошибки аутентификации, учётные записи перестали работать. Пользователи Neovim, которые привязались к Supermaven как к плагину, вынуждены искать замену - и это уже не первый раз, когда приобретения Cursor создают трения у нишевой аудитории.

**MCP-экосистема: Cursor как платформа, а не просто редактор** - В [r/ClaudeWorkflows](https://www.reddit.com/r/ClaudeWorkflows/comments/1ty4wxu/workflow_vs_code_extension_harness_manager_for/) появился VS Code-экстеншн "Harness Manager" для одним кликом переключения между промптами Claude Code, Copilot, Cursor и Windsurf. Отдельный тред в [r/DevvyBoard](https://www.reddit.com/r/DevvyBoard/comments/1tw6qxq/manage_your_devvyboard_from_inside_your_code/) показывает, что Cursor всё активнее становится MCP-хостом - инструменты вроде DevvyBoard теперь управляются прямо из редактора через Model Context Protocol. Cursor перестаёт быть "редактором с AI" и становится AI-платформой для разработки.

**Усталость от AI-инструментов - реальный сигнал** - В [r/ADHD_Programmers](https://www.reddit.com/r/ADHD_Programmers/comments/1tx69g6/lets_talk_about_ai_and_coding/) разработчик описывает: использование VSCode+Claude и Cursor с Claude "exhausting" - инструменты требуют постоянного внимания, чтобы направлять модель. Это не единичный голос: за последние 30 дней подобные комментарии появляются всё чаще, намекая на потолок UX текущего поколения агентных редакторов.

КЛЮЧЕВЫЕ ПАТТЕРНЫ из исследования:
1. Cursor делает ставку на собственные модели (Composer 2.5 = попытка уйти от зависимости от Anthropic/OpenAI при сохранении качества) - per [cursor.com/blog](https://cursor.com/blog/composer-2-5)
2. Связка Cursor + Claude Code фактически стала де-факто стеком для серьёзных разработчиков - per [dev.to comparison](https://dev.to/pockit_tools/cursor-vs-windsurf-vs-claude-code-in-2026-the-honest-comparison-after-using-all-three-3gof)
3. Windsurf продолжает давить на Cursor ценой ($15 vs $20/мес) - это основная точка оттока - per [shareuhack.com](https://www.shareuhack.com/en/posts/cursor-vs-claude-code-vs-windsurf-2026)
4. Credit-based pricing (2025) всё ещё вызывает недоверие - сообщество не забыло - per [r/cursor](https://reddit.com/r/cursor)
5. MCP-экосистема превращает Cursor из редактора в платформу - интеграция с внешними инструментами ускоряется - per [r/ClaudeWorkflows](https://www.reddit.com/r/ClaudeWorkflows/comments/1ty4wxu/)

---
## Лучшие реплики (Best Takes)

**"Я уже не понимаю, кто пишет код - я или оно"** - суть треда [r/ADHD_Programmers](https://www.reddit.com/r/ADHD_Programmers/comments/1tx69g6/): автор признаётся, что работа с Cursor + Claude превратилась в бесконечное "направление" модели, а не в программирование. Ни одного лайка на это не нужно - заголовок говорит сам за себя.

**"Has anyone used Cursor AI !!! Does it end up getting consumed too quickly???"** - [r/TeluguJournals](https://www.reddit.com/r/TeluguJournals/comments/1u28xsp/did_anyone_use_cursor_ai/) - три восклицательных знака и три вопросительных отлично передают энергию новичка, которому только что показали кредитный счётчик.

**Supermaven RIP** - пользователь [r/neovim](https://www.reddit.com/r/neovim/comments/1tp79ai/best_ai_code_completion_as_of_may_2026/) пишет: "Supermaven was acquired and sunset by Cursor... my account seems to no longer work." Cursor поглощает конкурентов и забывает о пользователях - классика M&A.

---

✅ All agents reported back!
├─ 🟠 Reddit: 16 threads
├─ 🟡 HN: 12 storys │ 469 points │ 295 comments
├─ 🗣️ Top voices: r/cursor, r/ClaudeWorkflows, r/TeluguJournals
└─ 📎 Raw results saved to ~/Documents/Last30Days/cursor-ai-code-editor-raw-v3.md

---

Я теперь в теме Cursor за последние 30 дней. Можно продолжить:
- Глубже по Composer 2.5: как это меняет расчёт стоимости против Claude API напрямую?
- Сравнение Cursor vs Windsurf подробнее - у кого лучше для командной работы?
- Что пишут про .cursorrules и конфигурацию агентов в r/cursor прямо сейчас?

Все ссылки на 28 тредов и статей у меня есть. Просто спроси.

## Codex

🌐 last30days v3.3.2 · synced 2026-06-11

Что я узнал:

**Codex вырвался за рамки кода — 5 миллионов пользователей в неделю** - 2 июня OpenAI объявила, что Codex стал инструментом "для всех ролей": 6 новых специализированных плагинов (продажи, аналитика данных, креативное производство, продуктовый дизайн, инвестиции в акции, инвестиционный банкинг) и конструктор Codex Sites. Аудитория выросла в 6 раз с февраля, а нетехнические специалисты (20% пользователей) растут в 3 раза быстрее разработчиков, per [VentureBeat](https://venturebeat.com/orchestration/openais-codex-update-lets-agents-build-interactive-enterprise-workspaces-via-sites-and-role-specific-plugins).

**Codex Sites - самый громкий анонс: деплой веб-приложений из одной фразы** - 2-6 июня OpenAI запустила Sites в preview: описываешь дашборд, внутренний инструмент или игру - Codex строит и разворачивает приложение на хостинге OpenAI с аутентификацией через ChatGPT. Пока доступно только для Business/Enterprise. Инди-хакеры раздражены: "no date announced for Plus or Pro access", per [DevToolPicks](https://devtoolpicks.com/blog/openai-codex-sites-launch-indie-hackers-2026).

**AWS + мобильное приложение: Codex встраивается в корпоративный стек** - 1 июня Codex стал доступен через Amazon Bedrock с корпоративной биллинговой и аутентификационной интеграцией (370 pts на [HN](https://news.ycombinator.com/item?id=48363132), 131 комментарий). 14 мая Codex появился в ChatGPT на iOS и Android: мобильный доступ к сессиям на Mac, уведомления о завершении задач, запуск новых задач с телефона. Windows - "coming soon".

**Безопасность: атака на цепочку поставок и фейковый сайт в топе Google** - В июне исследователи раскрыли вредоносный npm-пакет codexui-android (29 000 загрузок в неделю), который тихо похищал токены аутентификации Codex, per [The Hacker News](https://thehackernews.com/2026/06/openai-codex-authentication-tokens.html). Параллельно на [HN зафиксировали](https://news.ycombinator.com/item?id=48308943): первый результат Google по запросу "OpenAI Codex app" - поддельный малварь-сайт. OpenAI также запустила Daybreak - сервис сканирования уязвимостей в кодовой базе на основе Codex.

**Лимиты и баны - главная боль в сообществе** - Plus за $20/мес заканчивается раньше, чем ожидают пользователи: "I hit the cap pretty fast. It just seems like sometimes I don't even get through maybe 2 hours before I hit that cap", per [r/codex](https://www.reddit.com/r/codex/comments/1tw1ixv/openaicodex_how_far_do_you_get_daily_before_you/). Отдельную волну вызвал пост на [r/ChatGPT](https://www.reddit.com/r/ChatGPT/comments/1tx0a6m/openai_banned_my_account_the_day_after_i_paid_3/) о внезапной блокировке аккаунта с 30-40 агентами, годами клиентской работы и без объяснения причин. OpenAI эскалировала кейс только после вирусной огласки.

**Speculation на Reddit: Codex × GPT - единый продукт на горизонте** - Задержки объясняются подготовкой объединённого запуска: "They probably want a full fresh start. One clean deck. One strong unified product. GPT, Codex, agents, coding, tools, maybe even a new interface", per [r/codex](https://www.reddit.com/r/codex/comments/1u1ppnx/the_delay_makes_sense_now_openai_probably_wants_a/). OpenAI официально подтвердила интеграцию Codex в ChatGPT-приложение.

**1Password MCP Server - новый паттерн безопасного доступа к секретам для агентов** - 21 мая OpenAI и 1Password анонсировали MCP-сервер, который позволяет Codex безопасно получать доступ к паролям и API-ключам без их хардкода, per [HN](https://news.ycombinator.com/item?id=48223443). Это первый крупный корпоративный партнёрский паттерн для AI-агентов.

**Разработчики: лучший агент, но ~30% провалов на сложных задачах** - Отзывы в основном позитивные: DevX стал другим за полгода, задачи которые раньше падали - теперь работают. Но ~30% отказов на нетривиальных задачах и подкритика ценника Pro ($200/мес) как "The $200 Cloud Trap", per [Future Stack Reviews](https://future-stack-reviews.com/codex-review/).

---

## Ключевые паттерны из исследования

1. **Pivot to knowledge workers** - Codex целенаправленно переориентируется на нетехнических пользователей через плагины и Sites; разработчики уже не единственная ЦА
2. **Rate limits = самая острая боль** - Plus-лимиты слишком жёсткие для интенсивной работы; разрыв между $20 и $200 слишком велик
3. **Безопасность стала мишенью** - npm-атака + фейковые сайты сигнализируют: популярность инструмента привлекла злоумышленников, нужна осторожность при установке unofficial UI-обёрток
4. **Экосистемная интеграция ускоряется** - AWS, 1Password MCP, iOS/Android, GitHub Actions: Codex встраивается во всё больше enterprise-стеков
5. **Объединение продуктов на горизонте** - сообщество ожидает одного унифицированного продукта GPT + Codex; Sites и плагины - первые шаги к этому

---

## Best Takes

> "I hit the cap pretty fast. It just seems like sometimes I don't even get through maybe 2 hours before I hit that cap, and am I doing something wrong?" - пользователь [r/codex](https://www.reddit.com/r/codex/comments/1tw1ixv/) про Plus-лимиты, 3 июня

> "They probably want a full fresh start. One clean deck. One strong unified product. GPT, Codex, agents, coding, tools, maybe even a new interface." - спекуляция [r/codex](https://www.reddit.com/r/codex/comments/1u1ppnx/) о слиянии с GPT, 10 июня

> "OpenAI banned my account the day after I paid. 3 years of work, 30-40 Codex agents, all my client income — locked. No reason given. I'm the sole provider for my family." - вирусный пост [r/ChatGPT](https://www.reddit.com/r/ChatGPT/comments/1tx0a6m/), 4 июня (аккаунт восстановлен после огласки)

> "First thing you see when Googling 'OpenAI Codex app' is a fake malware website" - [HN/vashchylau](https://news.ycombinator.com/item?id=48308943), 28 мая - аккуратнее с тем, что качаете

> "OpenAI claimed they were using Codex itself to improve Codex, and the evidence is now undeniable. The improvement curve is steep and consistent in a way that suggests systematic, automated refinement." - [Zack Proser](https://zackproser.com/blog/openai-codex-review-2026), ежедневный пользователь

---

✅ All agents reported back!
├─ 🟠 Reddit: 3 threads
├─ 🟡 HN: 10 storys │ 832 points │ 608 comments
├─ 🗣️ Top voices: r/codex, r/ChatGPT
└─ 📎 Raw results saved to ~/work/news_vibe_coding/news_vibe_coding/digests/2026-06-11/openai-codex-raw-v3.md

---
Я теперь эксперт по Codex. Можно спросить:
- Как сообщество сравнивает Codex Sites с Cursor's background agents?
- Детали npm supply chain атаки: как защититься разработчикам, использующим Codex?
- Что означает интеграция в AWS Bedrock для enterprise-пользователей?

Все ссылки на 13 тредов (Reddit + HN) сохранены. Просто спросите.

