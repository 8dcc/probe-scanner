
match($0, /-?[0-9]+dBm/, strength) {
    STRENGTH=strength[0]
}

match($0, /SA(:[a-f0-9]{2}){6}/, mac) {
    gsub(/SA:/, "", mac[0])
    MAC=mac[0]
}

match($0, /Probe Request \(.*\)/, essid) {
    gsub(/(Probe Request \(|\))/, "", essid[0])
    if (length(essid[0]) != 0) {
        ESSID=essid[0]
		gsub(/\.[0-9]+/, "", $1)
		TIMESTAMP=$1
		# print TIMESTAMP " " STRENGTH " " MAC " \"" SSID "\""
        print "  [ "TIMESTAMP" ]>>>>[ " STRENGTH " ]>>%>>[ "MAC" ]>>?>>[ "ESSID" ]"
		system("")
    }
}
