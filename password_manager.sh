#!/bin/bash

Passfile="Passwords.txt"

echo "パスワードマネージャーへようこそ！"

while true; do
    
    echo -n "次の選択肢から入力してください(Add Password/Get Password/Exit)："
    read choice

    case $choice in
        "Add Password")
            echo -n "サービス名を入力してください："
            read service_name
            echo -n "ユーザー名を入力してください："
            read user_name
            echo -n "パスワードを入力してください："
            read password
            echo "$service_name:$user_name:$password" >> $Passfile
            gpg --yes --batch --passphrase="test" -c $Passfile
            rm $Passfile
            echo "パスワードの追加は成功しました。"
            ;;

       "Get Password")
    decrypted_data=$(gpg --yes --batch --passphrase="test" --decrypt $Passfile.gpg)
    
    echo -n "サービス名を入力してください："
    read search_service
    result=$(echo "$decrypted_data" | grep "^$search_service:")

    if [ -z "$result" ]; then
        echo "そのサービスは登録されていません。"
    else
        IFS=":" read -r r_service r_user r_pass <<< "$result"
        echo "サービス名：$r_service"
        echo "ユーザー名：$r_user"
        echo "パスワード：$r_pass"
    fi
    ;;


        "Exit")
            echo "Thank you!"
            exit 0
            ;;

        *)
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
            ;;
    esac
done

