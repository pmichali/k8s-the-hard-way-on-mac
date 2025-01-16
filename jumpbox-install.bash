# Get software
git clone --depth 1 \
  https://github.com/kelseyhightower/kubernetes-the-hard-way.git
echo "Cloned repo"
cd kubernetes-the-hard-way/
wget -q --show-progress \
  --https-only \
  --timestamping \
  -P downloads \
  -i downloads.txt
echo "Obtained downloads"
# Install kubectl
chmod +x downloads/kubectl
sudo cp downloads/kubectl /usr/local/bin/
echo "Installed kubectl"
