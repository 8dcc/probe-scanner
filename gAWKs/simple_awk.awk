
match($0, /-?[0-9]+dBm/, srtenght) {
    STRENGTH=strength[0]
}

match($0, /Probe Request \(.*\)/, essid) {
    gsub(/(Probe Request \(|\))/, "", essid[0])
    if (length(essid[0]) != 0) {
        ESSID=essid[0]
		# gsub(/\.[0-9]+/, "", $1)
		# TIMESTAMP=$1
		# print TIMESTAMP " " STRENGTH " " MAC " \"" SSID "\""
        print ESSID
		system("")
    }
}
