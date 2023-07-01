# Author Bayu Rizky A.M
# Youtube Pejuang Kentang

# framework
source lib/app.sh

# header Std::Main
Namespace: Std::Main

if grep -o "com.termux" <<< "$(pwd)" &>/dev/null; then true
else {
        cat <<< "[!] Wajib Menggunakan Termux"
        exit
};fi

{
        dpk=("dialog" "curl" "xh" "jq" "figlet" "boxes" "neofetch" "mpv" "screen")
        
        for install_dpk in "${dpk[@]}"; do
                if command -v "$install_dpk" &>/dev/null; then
                        true
                else
                        apt-get install "${install_dpk}" -y &>/dev/null
                fi
        done
}

{ apt-get install ncurses-utils -y &>/dev/null; }

# library yang di butuhkan
import.source [io:color.app,io:log.app]
import.source [io:match.app,inquirer:list.app]

# init
declare -A sig
declare astr=$(tput init)

# data warna
Wa=(
        [0]=$(__init:color__ ["mode","bold"]; eval color.hitam)
        [1]=$(__init:color__ ["mode","bold"]; eval color.merah)
        [2]=$(__init:color__ ["mode","bold"]; eval color.hijau)
        [3]=$(__init:color__ ["mode","bold"]; eval color.kuning)
        [4]=$(__init:color__ ["mode","bold"]; eval color.biru)
        [5]=$(__init:color__ ["mode","normal"]; eval color.magenta)
        [6]=$(__init:color__ ["mode","bold"]; eval color.cyan)
        [7]=$(__init:color__ ["mode","bold"]; eval color.putih)
        [8]=$(__init:color__ ["mode","reset"])
)

function DL(){
	function __init__(){
		shopt -s expand_aliases

		alias DL.run="DL::run::app"		
	}

	DL::run::app(){
		local req=$(
			curl -sLX POST "https://www.expertsphp.com/facebook-video-downloader.php" --insecure \
			-H "Content-Type: application/x-www-form-urlencoded" --data-raw "url=$1"
		)

		alok=$(grep -Eo "<video.*" <<< "$req")
		get_urldownload=$(cut -d "=" -f 2 <<< "$alok"|grep -Eo "(https|http)://[a-zA-Z0-9].*\""|tr -d '"')
		#echo "$get_urldownload"
		if test -z "$(head -1 <<< "$get_urldownload")"; then
		        echo "[!] Url tidak Valid"
		fi

		echo "[?] Mengunduh video : $1"
		echo
		file=$(echo "download_${RANDOM}.mp4")
		curl -L "$(head -1 <<< "$get_urldownload")" --insecure -o $file
		cp $file /sdcard
		echo
		echo "[!] File berhasil di unduh di /sdcard/$file"
		xdg-open "$file"
	}
}

read -p "(masukan url pideo nya)> " pidos
echo
echo "[+] Wait...";echo
eval DL
{ DL::run::app "$pidos"; }
