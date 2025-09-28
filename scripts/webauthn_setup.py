"""Basic tool for creating webauthn credentials."""
import sys
from webauthn import generate_registration_options
from webauthn import verify_registration_response
from webauthn import options_to_json
from app import config
from fastapi import FastAPI
from fastapi import Request
from fastapi.responses import HTMLResponse
import uvicorn

app = FastAPI()
options = generate_registration_options(
    rp_id=config.DOMAIN.split(":")[0],
    rp_name=config.USERNAME,
    user_name=config.USERNAME,
)

@app.get("/")
def prompt_cred() -> HTMLResponse:
    return HTMLResponse(f"""
    <script defer>
    (async function() {{
        const credential = await navigator.credentials.create({{
            publicKey: PublicKeyCredential.parseCreationOptionsFromJSON({ options_to_json(options) })
        }});
        fetch("/done", {{
            method: "POST",
            body: JSON.stringify(credential.toJSON())
        }});
        document.body.innerText = "Please check the utility output";
    }})();
    </script>""")

@app.post("/done")
async def done(request: Request):
    json = await request.json()
    verification = verify_registration_response(
        credential=json,
        expected_challenge=options.challenge,
        expected_rp_id=config.DOMAIN.split(":")[0],
        expected_origin="http://" + config.DOMAIN,
        require_user_verification=False
    )
    print(f"Credential ID: {verification.credential_id.hex()}\nPublic Key: {verification.credential_public_key.hex()}")

def main() -> None:
    uvicorn.run("webauthn_setup:app")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Aborted")
        sys.exit(1)
