# Oppgave 1 

Noen grunnsteiner i hubotscripting :)

## Del 1 - reply

Sjekk ut mappen `scripts` og opprett en `hello.coffee` eller `hello.js`.

Vi vil lage et script som kan kalles slik `hubot hello` hvor boten svarer `Hola!` tilbake

Sjekk ut [script-dokumentasjonen](https://github.com/github/hubot/blob/master/docs/scripting.md) for å sjekke ut oppsettet av et script.

Test ut at du får svar på formatene 
hubot hello
hubot: hello
@hubot hello

og ikke på formatet 
hello

## Del 2 - hear

Opprett en ny fil `anyone.js|coffee`. Her vil vi ha et script som fanger opp dersom noen skriver `anyone`. Hubot skal svare med `Pick me! Pick me!` 

Test ut at du får svar på formatene 
anyone there?
is anyone up for a drink?


## Del 3 - dokumentasjon

Sjekk ut `hubot help` eller `hubot help hello` - den finnes mest sannsynligvis ikke..? Om ikke du har laget den allerede, litt forut for din tid ;)

Sjekk ut avsnittet `Documenting Scripts` i [script-dokumentasjonen](https://github.com/github/hubot/blob/master/docs/scripting.md) og legg til dokumentasjon for `hello`-kommandoen. Husk at utkommentering av linjer er `//` om du skiver js :) 

