#!/bin/bash

# Nome do arquivo que contém as mensagens
FILE="messagesSQS.json"

# URL da fila SQS
QUEUE_URL="https://sqs.us-east-1.amazonaws.com/{{aws_account_id}}/MyQueue"

# Lê o arquivo e conta o número total de mensagens
total_messages=$(jq '. | length' $FILE)

# Define o tamanho do lote
batch_size=10

# Itera sobre o arquivo em lotes de 10 mensagens
for (( i=0; i<$total_messages; i+=batch_size ))
do
    # Extrai um lote de mensagens
    jq ".[$i:$((i+batch_size))]" $FILE > batch$i.json

    # Envia o lote para o SQS
    # aws sqs send-message-batch --queue-url $QUEUE_URL --entries file://batch.json
done

# Remove o arquivo temporário batch.json
rm -f batch.json
