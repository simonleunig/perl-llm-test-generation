# Replication package

This package contains the artifacts for the open-source evaluation described in *LLM-Driven
Test and Test-Repair Automation for Legacy Perl Systems: An Empirical Study at IBM*.

Two models were used to generate tests for three CPAN distributions. Tests that failed were
automatically repaired, and coverage was measured for the tests that passed. Each
model-subject combination was run three times. The industrial repositories used in the
study are proprietary and are therefore not included in this package.

The package includes the prompts, generated tests, results for each stage, and coverage
measurements. It also includes a Docker image that re-runs the recorded tests, one
combination at a time.

## Layout

```text
results/<subject>/<model>/<run>/<stage>/
```

|          |                                                                 |
| -------- | --------------------------------------------------------------- |
| subjects | [`XML-Simple-2.25`](https://metacpan.org/release/GRANTM/XML-Simple-2.25), [`Tie-IxHash-1.23`](https://metacpan.org/release/CHORNY/Tie-IxHash-1.23), [`Path-Class-0.37`](https://metacpan.org/release/KWILLIAMS/Path-Class-0.37) |
| models   | `Llama-3.3-70B-Instruct`, `Mistral-Small-3.1-24B-Instruct-2503` |
| runs     | `1`, `2`, `3`                                                   |
| stages   | `initial`, `repair`, `coverage`                                 |

Each stage contains the generated `.t` files and `perl_test_results.json`.

The files `initial.json` and `repair.json` contain the prompts and the models' responses.
The file `coverage.json` contains the coverage tables. During the coverage stage,
`.t.disabled` files were excluded from the measurement.

## Re-running

```bash
docker build -t perl-eval .
docker run --rm perl-eval # shows the available options
docker run --rm --network none --read-only --tmpfs /tmp \
  perl-eval XML-Simple-2.25 Llama-3.3-70B-Instruct 1 initial
```

The same commands also work with `podman` instead of `docker`. The four arguments select
one specific combination of subject, model, run, and stage. The stage defaults to
`initial`.

The Docker image contains Perl 5.26.3 and the module versions used in the paper. The
distributions are unpacked without being installed, so the tests are run directly against
the included source code.

After the run, the totals recorded during the study are printed for comparison. When the
`coverage` stage is run, the coverage report is also generated again.

`prove` may show fewer assertions than the recorded totals. A file that does not execute or
exits abnormally is recorded as a failing entry, while `prove` reports this at the file
level rather than as an assertion.

## Third-party material

The prompt fields in `initial.json` and `repair.json` contain source code originating from
the CPAN distributions `XML-Simple-2.25`, `Tie-IxHash-1.23`, and `Path-Class-0.37`.

Copyright in these components remains with their respective authors and contributors. These
components were obtained from CPAN and are distributed under their respective original
license terms. Users of this replication package are responsible for complying with the
applicable third-party license requirements.

This repository does not alter, replace, or supersede the license terms that apply to any
third-party material included herein.
