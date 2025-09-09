#!/bin/sh

# ألوان للتنسيق
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# دالة للطباعة الملونة
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# دالة شريط التقدم
progress_bar() {
    local duration=${1}
    local bars=20
    local sleep_interval=$(echo "scale=3; $duration/$bars" | bc)
    
    for ((i=0; i<=bars; i++)); do
        printf "${BLUE}["
        for ((j=0; j<i; j++)); do printf "█"; done
        for ((j=i; j<bars; j++)); do printf " "; done
        printf "] %3d%%${NC}\r" $((i*100/bars))
        sleep $sleep_interval
    done
    printf "\n"
}

clear
echo "=============================================="
echo "    Uni_Stalker Installation Script"
echo "          Uni_Stalker V1.0"
echo "=============================================="
echo ""

# التحقق من الاتصال بالإنترنت
print_status "Checking internet connection..."
if ping -c 1 github.com >/dev/null 2>&1; then
    print_success "Internet connection is available"
else
    print_error "No internet connection!"
    exit 1
fi

# التنزيل
print_status "Downloading Uni_Stalker from GitHub..."
wget -O /tmp/Uni_Stalker.tar.gz https://github.com/MARKETTV1/union/raw/refs/heads/main/Uni_Stalker.tar.gz

if [ $? -eq 0 ]; then
    print_success "Download completed successfully"
else
    print_error "Download failed!"
    exit 1
fi

# فك الضغط
print_status "Extracting files to plugins directory..."
cd /tmp/
tar -xzf Uni_Stalker.tar.gz -C /usr/lib/enigma2/python/Plugins/Extensions/

if [ $? -eq 0 ]; then
    print_success "Extraction completed successfully"
else
    print_error "Extraction failed!"
    exit 1
fi

# تنظيف الملف المؤقت
print_status "Cleaning temporary files..."
rm -f /tmp/Uni_Stalker.tar.gz
print_success "Temporary files removed"

# تثبيت الحزم المطلوبة
print_status "Updating package list and installing dependencies..."
print_warning "This may take a few minutes..."
progress_bar 5

opkg update
if [ $? -eq 0 ]; then
    print_success "Package list updated"
else
    print_error "Failed to update package list"
    exit 1
fi

opkg install python3-psutil
if [ $? -eq 0 ]; then
    print_success "python3-psutil installed successfully"
else
    print_warning "Failed to install python3-psutil, continuing anyway..."
fi

# إعادة التشغيل
print_status "Restarting Enigma2..."
print_warning "Please wait while the system restarts..."
progress_bar 3

killall -9 enigma2

echo ""
echo "=============================================="
print_success "Installation completed successfully!"
print_success "Uni_Stalker has been installed and activated"
echo "=============================================="
echo ""
