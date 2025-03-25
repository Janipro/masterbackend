export const taskTitle = "Beregn arealet av flere trekanter";

export const taskDescription = `
    Lag et Python-program som regner ut arealet av fem trekanter. Du skal bruke en liste med grunnlinje og høyde for hver trekant.

    For hver trekant i listen, beregn arealet med formelen:

    areal=grunnlinje*høyde/2

    Skriv ut arealet for hver trekant.
    Hvis arealet er større enn 50, skriv ut meldingen "Stor trekant!" i tillegg.

    Her er listen med grunnlinje og høyde for hver trekant som du skal bruke:

    trekanter = [
        [10, 7],
        [12, 9],
        [8, 10], 
        [15, 6],
        [6, 8]
    ]

    Grunnlinje = 10, Høyde = 7
    Grunnlinje = 12, Høyde = 9
    Grunnlinje = 8, Høyde = 10
    Grunnlinje = 15, Høyde = 6
    Grunnlinje = 6, Høyde = 8
    `;

export const themes = ["if-setning", "for-løkke"];

export const studentLevel = "VG2";

export const codeSolution = `
    trekanter = [
        [10, 7],
        [12, 9],
        [8, 10],
        [15, 6],
        [6, 8]
    ]

    for trekant in trekanter:
        grunnlinje = trekant[0]
        hoyde = trekant[1]

        areal = grunnlinje * hoyde / 2
        print(f"Arealet av trekanten er: {areal}")

        if areal > 50:
            print("Stor trekant!")
    `;

export const expectedOutput = `
    Arealet av trekanten er: 35.0
    Arealet av trekanten er: 54.0
    Stor trekant!
    Arealet av trekanten er: 40.0
    Arealet av trekanten er: 45.0
    Arealet av trekanten er: 24.0
    `;
