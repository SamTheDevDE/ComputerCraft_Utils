-- encryption.lua

local encryption = {}

--- XOR-encrypt or decrypt a string using a key
-- @param text The input string (plain or encrypted)
-- @param key  The key used for encryption/decryption
-- @return The result string
function encryption.xor(text, key)
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        local keyChar = key:sub((i - 1) % #key + 1, (i - 1) % #key + 1)
        local encryptedChar = string.char(bit.bxor(char:byte(), keyChar:byte()))
        result = result .. encryptedChar
    end
    return result
end

return encryption
