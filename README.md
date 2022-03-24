# Sign mender artifact with private key

This actions signs an existing artifact [artifact](https://docs.mender.io/3.1/artifact-creation) file.

The action is running in a docker container.

It uses the current mender-artifact version _`3.6.1`_. 
See the [mender-artifact](https://docs.mender.io/3.1/artifact-creation/state-scripts) documentation page for more information.


## Inputs

### `artifact-input-name`

_Description:_
Name of the mender artifact.

_Required:_ *true*

### `artifact-output-path`

_Description:_
Output path of the signed mender artifact.

_Required:_ *true*

### `signed-artifact-name`

_Description:_
The name of the signed mender artifact.

_Required:_ *true*

### `signing-key-path`

_Description:_
Path to the private signing key.

_Required:_ *true*

## Outputs

### ` signed-artifact-path`

The path to the signed mender artifact.

## Example usage

```yaml

      - name: Create signing key
        run: |
          {
            echo '${{ secrets.SIGNING_KEY }}'
          } >> signing.key

      - name: Sign mender artifact
        id: signed_artifact
        uses: KevinRohn/create-mender-artifact@main
        with: 
          artifact-input-name: "dist/artifact.mender"
          artifact-output-path: "dist"
          signed-artifact-name: "artifact-signed"
          signing-key-path: signing.key

      - name: check-output
        run: |
          echo ${{ steps.signed_artifact.outputs.signed-artifact-path  }} # dist/artifact-signed.mender

      - name: Remove signing key
        run: rm signing.key
```
