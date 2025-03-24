const buildPrompt = ({ taskTitle, taskDescription, themes, studentLevel, codeSolution, expectedOutput, code, userCodeOutput }) => {
    return `
    ### Oppgavetittel:
    ${taskTitle}

    ### Oppgavebeskrivelse:
    ${taskDescription}

    ### Oppgavenivå:
    ${studentLevel}

    ### Relevante temaer:
    ${themes.join(', ')}

    ### Foreslått kodefasit:
    ${codeSolution}

    ### Forventet output:
    ${expectedOutput}

    ### Elevens kode:
    \`\`\`python
    ${code}
    \`\`\`

    ### Elevens kode ouput:
    ${userCodeOutput}

    Din oppgave er å analysere elevens kode og gi **hjelpsom, pedagogisk tilbakemelding**.

    - Ikke gi fasitsvaret direkte.
    - IKke gi kode som inneholder fasit.
    - Hvis det er feil i koden, forklar tydelig og veiled eleven til hvordan det kan fikses uten å avsløre fasitkoden.
    - Hvis koden kjører men gir feil resultat, hjelp eleven med å **resonnere seg fram til hva som kan være galt**.
    - Bruk et språk og fagbegreper som passer for en elev på ${studentLevel}-nivå. Forklar på en enkel og forståelig måte, uten å bruke avanserte uttrykk som ikke er dekket på dette trinnet.
    - Vær støttende og oppmuntrende, som en god lærer.
    - Svar relativt kort, men presist.
    - Ikke inkluder en overflødig innledning og avslutning i veiledningen, som for eksempel Hei! eller Lykke til!.
    - Begrens avslutningen til maksimum 1 kort oppmuntrende setning.
    - Ikke refer direkte til kodefasiten. Eleven har ikke tilgang på den foreslåtte kodefasiten.
    - Hvis koden gir korrekt output, så påpek at oppgaven er løst og deretter foreslå hvordan eleven kan forbedre løsningen hvis det er noen åpenbare forbedringer.
    - Inkluder maksimum 2 oppmuntrende setninger som ikke direkte referer til noe i elevens koden.

    Svar på norsk.
    `;
};

export default buildPrompt;