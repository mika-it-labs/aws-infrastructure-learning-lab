"""必要なファイルだけをZIPのルートへ収録する（AWS操作なし）。"""
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

ROOT = Path(__file__).resolve().parent
FILES = (
    "app.py",
    "tests/test_app.py",
    "buildspec.yml",
    "appspec.yml",
    "scripts/validate.sh",
)


def main():
    output = ROOT / "dist" / "source.zip"
    output.parent.mkdir(exist_ok=True)
    for name in FILES:
        if not (ROOT / name).is_file():
            raise FileNotFoundError(name)
    with ZipFile(output, "w", compression=ZIP_DEFLATED) as archive:
        for name in FILES:
            archive.write(ROOT / name, arcname=name)
    with ZipFile(output) as archive:
        if archive.testzip() is not None or set(archive.namelist()) != set(FILES):
            raise RuntimeError("ZIP validation failed")
        print("\n".join(archive.namelist()))
    print("Created:", output.name)


if __name__ == "__main__":
    main()
