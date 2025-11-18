# Life in the UK practice

> No trackers,
> No ads,
> Free.

More than 3000 questions from various sources.

This is a fork of the original [Life in the UK test](https://maxwellito.github.io/life-in-the-uk/) by maxwellito, intended for personal practice and question auditing using LLMs.

## Application Link

The application is hosted at: [https://yiminglin-ai.github.io/life-in-the-uk-2/](https://yiminglin-ai.github.io/life-in-the-uk-2/)

## Repository

Code is available at: [https://github.com/yiminglin-ai/life-in-the-uk-2](https://github.com/yiminglin-ai/life-in-the-uk-2)

## Question Auditing Workflow

This repository contains scripts to audit and correct the question database using LLMs.

1.  **Split Questions**: Run `python3 split_questions.py` to generate batches in `audit_batches/`.
2.  **Audit**: Use an LLM (like ChatGPT or Claude) with the `audit_prompt.txt` to review each batch from `audit_batches/`.
3.  **Save**: Save the corrected JSON files in `audit_batches_corrected/`.
4.  **Merge**: Run `python3 merge_questions.py` to update `questions_base.json` with your corrections.
5.  **Deploy**: Run `./deploy.sh` to publish your changes to the website.

## Deployment

To update the live site (e.g., after auditing questions), run:

```bash
./deploy.sh
```

This script moves the relevant files to the `gh-pages` branch under the `life-in-the-uk/` directory and pushes the changes.
