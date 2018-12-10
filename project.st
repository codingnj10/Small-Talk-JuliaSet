width := 1920.
height := 1080.
max := 5.
a := 1.2 .
b := 0.5 .
outputFile := 'file.ppm'.
radius := 2.0 .

Object subclass: Julia [
    | Colors | " instance variables "
    <comment:
        'I represent a place to deposit and withdraw money'>
    Julia class >> new [
        <category: 'instance creation'>
        | r |
        r := super new.
        r init.
        ^r
    ]

    init [
        <category: 'initialization'>
        Colors := #('255 243 182 ' '32 53 84 ' '100 12 55 ' '88 185 34 ' '200 154 8 ' '0 0 255 ' )
    ]

    generatePixels: max and: height and: width  and: a and: b[
        | fileReader sendX sendY oldX oldY n hStep wStep radius distance c|
        fileReader := FileStream open: 'test.ppm' mode: FileStream write.
        'P3 1920 1080 255 ' nextPutAllOn: fileReader.

        radius := 2.0.
        hStep := (radius * 2) / (height - 1).
        wStep := (radius * 2) / (width -1).

        1 to: height do: [:i | 
            1 to: width do: [:j |
                n := 1.
                sendX := (0.0-radius) + ( j * wStep).
                sendY := (radius) - (i * hStep).
                distance := ((sendX * sendX) + (sendY * sendY)) sqrt.
                [((distance < 2) & (n < max))] whileTrue: [
                    oldX := sendX.
                    oldY := sendY.
                    sendX := (oldX * oldX) - (oldY * oldY) + a.
                    sendY := (2 * oldX * oldY) + b.
                    " sendX := (sendX exp) * (sendY cos) + a.
                    sendY := (sendX exp) * (sendY sin) + b. "
                    n := n + 1.
                    distance := ((sendX * sendX) + (sendY * sendY)) sqrt.
                ].

                " Calculate the color "
                c := Colors at: (n+1).
                " Output it to the file "
                c nextPutAllOn: fileReader.
            ].
        ].
    ]
]

j := Julia new.
j generatePixels: max and: height and: width and: a and: b.