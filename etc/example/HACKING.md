```bash
source dot.env
export MKLATEX_PATH=../../ ; make -f ../../cli/main.mk MKLATEX_INCLUDE_PRE=etc/make/common.mk all
```

```bash
source dot.env
export MKLATEX_PATH=../../ ; make -f ../../cli/main.mk MKLATEX_INCLUDE_PRE=etc/make/common.mk build/tex/sec1.pdf
```

```bash
source dot.env
export MKLATEX_PATH=../../ ; make -f ../../cli/main.mk MKLATEX_INCLUDE_PRE=etc/make/common.mk distclean
```
