import nox
from nox import Session, session

nox.options.error_on_external_run = True
nox.options.reuse_existing_virtualenvs = True


@session(venv_backend="none")
def build(s: Session) -> None:
    entry_point = "pyinstaller-demo"
    args = ["pyinstaller"]
    args.append("--onefile")
    args.extend(["--name", entry_point])
    args.extend(["--distpath", "dist"])
    args.extend(["--specpath", "build"])
    args.extend(["--workpath", "build"])
    args.append(f"{entry_point}-wrapper.py")
    s.run(*args)
