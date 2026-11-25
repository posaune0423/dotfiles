# eMudhra 中間 CA 鍵漏洩の対応。
# 標準の pip3 に、問題の root を取り除いた /etc/ssl/cert.pem を使わせる。
# Xcode 内の Python の stdlib（sitecustomize.py）は署名済みバンドルで書き込めないため、環境変数で指定する
set -gx PIP_CERT /etc/ssl/cert.pem
