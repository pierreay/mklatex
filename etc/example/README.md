<h1 align="center"> <a href="WEBSITE_URL">Title</a></h1>
<h4 align="center">Subtitle</h4>

---

# FILES

- [build](./build): Build directory (PDFs from LaTeX, DrawIO, Inkscape)
- [doc](./doc): Documents related to the paper and submission
- [etc](./etc): Configuration files (Make, LaTeX)
- [examples](./examples): Reusable snippets of code
- [modules](./modules): Git submodules ([mklatex](https://github.com/pierreay/mklatex))
- [out](./out): Final output directory (after build, post-processed PDF of the document)
- [src](./src): Sources of the paper (LaTeX, BibTeX, DrawIO, Inkscape)

# CONTRIBUTING

> [!TIP]
> Spinellis, Diomidis. *Advice for writing LaTeX documents*. 11 février 2026. [https://github.com/dspinellis/latex-advice](https://github.com/dspinellis/latex-advice).

## Web environment

For **editing** the source code:

- Use the basic Gitlab features to create/find/edit files
- Use the advanced [Gitlab Web IDE](https://docs.gitlab.com/user/project/web_ide/) (press `.` to open it instantly from the project repository page)

For **viewing** the compiled document:
- [Open](https://gitlab.laas.fr/pierreay/emsok/-/jobs/artifacts/master/browse?job=build-latex) the latest build as PDF file (browse under the `out/` directory)
- [Download](https://gitlab.laas.fr/pierreay/emsok/-/jobs/artifacts/master/download?job=build-latex) the latest build as ZIP file

## Local environment

1. **Initialize the submodules** of the repository:

```bash
git submodule update --init --recursive
```

2. Source the **project environment**:

```bash
source .env
```

3. Verify the setup by **printing the help**:

```bash
mklatex -h
make help
``` 

> [!IMPORTANT]
> In any of the following code blocks, either in Docker or in native system, the environment of the project must have been sourced.

> [!TIP]
> One may use [dotenv](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/dotenv/README.md) or a similar tool to source it automatically

### Docker

A Docker container is provided by [mklatex](https://github.com/pierreay/mklatex) to ensure reproducible builds across operating systems.
The container state is persistent between executions.

To simply **build the document using Docker from scratch**, run:

```bash
mklatex docker all
```

---

To use the Docker container **step-by-step**:

1. **Build** the Docker container:

```bash
mklatex docker init
```

2. **Get a shell** on the Docker container: 

```bash
mklatex docker shell
```

3. Move into the project directory and **source the environment**:

```bash
docker> cd /latex && source .env
```

4. From here, one can use the same commands as in the [Native](#native) section.

> [!IMPORTANT]
> If running graphical programs from the Docker container fails, ensure X11 authorize local connections by running on the host:
> `sudo xhost +local:docker=`

### Native

- Build the **entire document**:

```bash
make
```

- Build a **document subset** (specific file) and open it once done:

```bash
mklatex --open src/tex/FILE.tex
```

- Grep for **compilation warnings and errors**:

```bash
mklatex latex showerrs
```

- **Clean the document build** to its initial state:

```bash
make distclean
```
