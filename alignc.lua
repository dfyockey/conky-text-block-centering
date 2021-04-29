-- This is a lua script for centering a block of text in conky.
--
-- Reads lines of text from textfile, then adds a conky center
-- alignment object to the beginning of each line while equalizing the
-- length of each line.
--
-- For proper functionality...
-- 	1) Use a $lua_parse line in conky's TEXT or .text section to run
--	   the script, with a text file as the argument.
--     E.g.: ${lua_parse conky_alignc /home/User/mytextfile}
-- 	2) Use a monospace font. If your default font isn't monospace,
--	   preceed the $lua_parse line with a $font line to change to
--     monospace and follow it with a $font line to change it back.
--
--
-- License : MIT License
--
--  Copyright (c) 2018 David Yockey
--
--  Permission is hereby granted, free of charge, to any person
--  obtaining a copy of this software and associated documentation files
--  (the "Software"), to deal in the Software without restriction,
--  including without limitation the rights to use, copy, modify, merge,
--  publish, distribute, sublicense, and/or sell copies of the Software,
--  and to permit persons to whom the Software is furnished to do so,
--  subject to the following conditions:
--
--  The above copyright notice and this permission notice shall be
--  included in all copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
--  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
--  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
--  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
--  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
--  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.

function conky_alignc(textfile)

    if conky_window == nil then
        return
    end

	local result = "File Not Found:\n  "..textfile
    local ctrcode = "${alignc}"
	local lines = {}
	local longest  = 0
	local msgwidth = 0
	
	-- Check for file existance
	local text = io.open(textfile, "rb")
	
	if text	then
	
		-- Close file so io.lines can reopen
		text:close()
		
		-- Read in lines and determine which is the longest
		for line in io.lines(textfile) do
			local len = utf8.len(line)
			if len > longest then longest = len end
			lines[#lines + 1] = line
		end

		-- For each line: preface it with a conky center alignment
		-- object, find the difference in length between the it and the
		-- longest line, and add a number of spaces equal to that
		-- difference to the line's end to equalize its length to that
		-- of the longest line.
		for i = 1, #lines do
			local len = utf8.len(lines[i])
			lines[i] = ctrcode..lines[i]..string.rep(" ", longest-len)
		end
		
		result = table.concat(lines,"\n")
	end

	return result
end

