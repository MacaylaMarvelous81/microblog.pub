{
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  jinja2,
  fastapi,
  pycryptodome,
  bcrypt,
  itsdangerous,
  python-multipart,
  tomli,
  httpx,
  sqlalchemy,
  alembic,
  bleach,
  prompt-toolkit,
  tomli-w,
  python-dateutil,
  beautifulsoup4,
  html5lib,
  mf2py,
  pygments,
  loguru,
  pillow,
  blurhash-python,
  html2text,
  feedgen,
  emoji,
  aiosqlite,
  cachetools,
  humanize,
  tabulate,
  asgiref,
  supervisor,
  invoke,
  uvicorn,
  brotli,
  greenlet,
  mistletoe,
  pebble,

  # boussole
  setuptools,
  click,
  watchdog,
  libsass,
  pyaml,
  colorama,
  colorlog,

  # pyld
  frozendict,
  lxml,
  requests,
}:
let
  boussole = buildPythonPackage {
    pname = "boussole";
    version = "2.1.3";

    src = fetchFromGitHub {
      owner = "sveetch";
      repo = "boussole";
      rev = "2.1.3";
      hash = "sha256-8jVND42k46sq+TJwuxXXN4Lebd3h2qz5RmkHyHVChnA=";
    };

    pyproject = true;

    build-system = [ setuptools ];

    dependencies = [
      click
      watchdog
      libsass
      pyaml
      colorama
      colorlog
    ];
  };
  pyld = buildPythonPackage {
    pname = "pyld";
    version = "2.0.4";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "digitalbazaar";
      repo = "pyld";
      rev = "v2.0.4";
      hash = "sha256-XKPAGOLuLk2VOnvdICo2sNPdeoQok+oGScWXeuYmi4o=";
    };

    build-system = [ setuptools ];

    dependencies = [
      cachetools
      frozendict
      lxml
      requests
    ];
  };
in buildPythonPackage {
  pname = "microblogpub";
  version = "0-unstable-2025-09-27";

  src = ./.;

  pyproject = true;

  build-system = [ poetry-core ];

  dependencies = [
    jinja2
    fastapi
    pycryptodome
    bcrypt
    itsdangerous
    python-multipart
    tomli
    httpx
    sqlalchemy
    alembic
    bleach
    prompt-toolkit
    tomli-w
    python-dateutil
    beautifulsoup4
    html5lib
    mf2py
    pygments
    loguru
    pillow
    blurhash-python
    html2text
    feedgen
    emoji
    pyld
    aiosqlite
    cachetools
    humanize
    tabulate
    asgiref
    supervisor
    invoke
    boussole
    uvicorn
    brotli
    greenlet
    mistletoe
    pebble
  ]
    ++ httpx.optional-dependencies.http2
    ++ sqlalchemy.optional-dependencies.asyncio
    ++ uvicorn.optional-dependencies.standard;
}
