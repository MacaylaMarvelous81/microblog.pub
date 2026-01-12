import re
import unicodedata

import bleach


def slugify(text: str) -> str:
    value = unicodedata.normalize("NFKC", text)
    value = re.sub(r"[^\w\s-]", "", value.lower())
    return re.sub(r"[-\s]+", "-", value).strip("-_")


def clean_if(condition: bool, *args, **kwargs):
    if condition:
        return bleach.clean(*args, **kwargs)

    return args[0]
