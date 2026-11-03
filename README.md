# Morg

a music organizer.

## Running

```sh
sbcl --eval "(asdf:load-system :morg)" \
     --eval "(morg:main)" \
     --quit
```

## Building

```sh
sbcl --eval "(asdf:make :morg)"
ls ./morg-sbcl*
```

same with other lisps.

## Author and License

`morg` was written by LostEclair and is distributed
under the terms of the MIT license.
