(
    -- Open the FileStream to read from disc
    local theFileStream = openFile "C:/test.txt"
    -- Initialize an empty Array to store the result
    local asWords = #()
    -- Enter a while loop that terminates once the full file has been read
    while ((eof theFileStream) == false) do
    (
        -- Read one set of characters delimited by a comma...
        local sWord = readDelimitedString theFileStream ","
        -- ...And append it to the result array
        append asWords sWord
    )
    -- Close the FileStream
    close theFileStream
    -- Cleanup memory used by the FileStream
    free theFileStream
    -- Display the resulting Array in the Listener
    format "asWords: %\n" asWords
)