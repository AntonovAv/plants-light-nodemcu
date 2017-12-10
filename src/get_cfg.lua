local fd = file.open("cfg")
if fd then
    local cfg = fd.read()
    local ok, res = pcall(sjson.decode, cfg)
    cfg = nil;
    fd.close()
    fd = nil
    if ok then
        return res
    end
end
