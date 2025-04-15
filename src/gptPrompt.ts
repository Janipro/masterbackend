const buildPrompt = ({ taskTitle, taskDescription, requirements, level, expectedCode, expectedOutput, code, userCodeOutput, codeTemplate }) => {
    let codeTemplateString = `\n### Oppgavens kodemal:\n${codeTemplate}`;

    return `
    ### Oppgavetittel:
    ${taskTitle}

    ### Oppgavebeskrivelse:
    ${taskDescription}

    ### Oppgavenivå:
    ${level}

    ### Relevante oppgavekrav:
    ${requirements.join(', ')}

    ### Foreslått kodefasit:
    ${expectedCode}

    ### Forventet output:
    ${expectedOutput}

    ${codeTemplate ? codeTemplateString : ''}

    ### Elevens kode:
    \`\`\`python
    ${code}
    \`\`\`

    ### Elevens kode ouput:
    ${userCodeOutput}

    Din oppgave er å analysere elevens kode og gi **hjelpsom, pedagogisk tilbakemelding**.

    Ta spesialt hensyn til følgende:
    - Ikke gi fasitsvaret direkte.
    - IKke gi kode som inneholder fasit.
    - Hvis det er feil i koden, forklar tydelig og veiled eleven til hvordan det kan fikses uten å avsløre fasitkoden.
    - Hvis koden kjører men gir feil resultat, hjelp eleven med å **resonnere seg fram til hva som kan være galt**.
    - Bruk et språk og fagbegreper som passer for en elev på ${level}-nivå. Forklar på en enkel og forståelig måte, uten å bruke avanserte uttrykk som ikke er dekket på dette trinnet.
    - Vær støttende og oppmuntrende, som en god lærer.
    - Svar relativt kort, men presist.
    - Ikke inkluder en overflødig innledning og avslutning i veiledningen, som for eksempel Hei! eller Lykke til!.
    - Begrens avslutningen til maksimum 1 kort oppmuntrende setning.
    - Ikke refer direkte til kodefasiten. Eleven har ikke tilgang på den foreslåtte kodefasiten.
    - Hvis koden gir korrekt output, så påpek at oppgaven er løst og deretter foreslå hvordan eleven kan forbedre løsningen hvis det er noen åpenbare forbedringer.
    - Inkluder maksimum 2 oppmuntrende setninger som ikke direkte referer til noe i elevens koden.
    - Hvis tilbakemeldingen inneholder matematiske formler, skal disse skrives slik man normalt ville skrevet dem for hånd — altså med tall, bokstaver, operatorer og parenteser. Unngå bruk av LaTeX-formattering, innebygde funksjoner eller spesialkoder som \frac{}. Eksempel på uønsket format: \( \frac{1}{2} \times \text{base} \times \text{høyde} \). Eksempel på ønsket format: (1/2) * base * høyde.
    - Hvis Elevens output er den samme som forventet output, men det er noen ubetydelige forskjeller i formatering eller stavelse, så gi eleven hint om hvordan eleven kan få riktig output. Sammenligningen av ouputs gjøres med små bokstaver og uten ledende eller etterfølgende mellomrom.

    Svar på norsk.
    `;
};

export default buildPrompt;