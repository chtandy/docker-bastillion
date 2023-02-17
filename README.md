### 參考
- [Bastillion](https://github.com/bastillion-io/Bastillion)      
- [一款基於Web的SSH控制終端](https://www.gushiciku.cn/pl/pXDz/zh-tw)   


### 備註
- 一款可以使用web base 的工具來使用ssh terminal，有著以下優點：
  1. 使用者管理
  2. 設定檔管理
  3. 主機管理
  4. 安全性管理，使用2FA
  5. Audit 機制，記錄每個連線下所操作的完整流程
 
### init user & passwd
```
username:admin
password:changeme
``` 

### 首次使用，先定義使用自定義key 或是系統產生
### 自定義key ,若為空值則系統自動產生
- 將privatekey 與 publickey 放在./data/keyfile 目錄下
- public key 副檔名 .pub
- 第一次啟動完成後，key就可以移除


### 開啟audit 審核功能
- 編輯`.env`,將`EnableInternalAudit`,將他設置為'true' 



