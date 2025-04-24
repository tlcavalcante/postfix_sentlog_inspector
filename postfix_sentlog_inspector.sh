#!/usr/bin/env bash

LOG_FILE="/var/log/mail.log"

sanitize_input() {
    local input="$1"
    if [[ ! "$input" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        printf "Erro: endereço de e-mail inválido: '%s'\n" "$input" >&2
        return 1
    fi
    return 0
}

check_log_file() {
    if [[ ! -f "$LOG_FILE" || ! -r "$LOG_FILE" ]]; then
        printf "Erro: log '%s' inexistente ou inacessível\n" "$LOG_FILE" >&2
        return 1
    fi#!/usr/bin/env bash

LOG_FILE="/var/log/mail.log"

sanitize_input() {
    local input="$1"
    if [[ ! "$input" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        printf "Erro: endereço de e-mail inválido: '%s'\n" "$input" >&2
        return 1
    fi
    return 0
}

check_log_file() {
    if [[ ! -f "$LOG_FILE" || ! -r "$LOG_FILE" ]]; then
        printf "Erro: log '%s' inexistente ou inacessível\n" "$LOG_FILE" >&2
        return 1
    fi
}

extract_message_ids_by_sender() {
    local sender="$1"
    local ids

    if ! ids=$(grep -E "postfix/(qmgr|cleanup).* from=<${sender}>" "$LOG_FILE" | awk '{print $6}' | sed 's/://g' | sort -u); then
        printf "Erro ao extrair IDs de mensagens\n" >&2
        return 1
    fi

    if [[ -z "$ids" ]]; then
        printf "Nenhuma mensagem encontrada para o remetente: %s\n" "$sender" >&2
        return 1
    fi

    printf "%s\n" "$ids"
}

extract_recipients_and_dates() {
    local message_id="$1"
    local entries

    if ! entries=$(grep -E "${message_id}: to=<" "$LOG_FILE"); then
        printf "Erro ao processar ID de mensagem: %s\n" "$message_id" >&2
        return 1
    fi

    if [[ -z "$entries" ]]; then
        return
    fi

    while IFS= read -r line; do
        local date; date=$(printf "%s\n" "$line" | awk '{printf "%s %s %s", $1, $2, $3}')
        local recipient; recipient=$(printf "%s\n" "$line" | sed -nE "s/.* to=<([^>]*)>.*/\1/p")
        if [[ -n "$recipient" ]]; then
            printf "%s\t%s\n" "$date" "$recipient"
        fi
    done <<< "$entries"
}

print_table_header() {
    printf "DATA\t\t\tDESTINATÁRIO\n"
    printf -- "-------------------------------\n"
}

main() {
    if [[ $# -ne 1 ]]; then
        printf "Uso: %s <remetente@dominio>\n" "$0" >&2
        return 1
    fi

    local sender="$1"

    if ! sanitize_input "$sender"; then
        return 1
    fi

    if ! check_log_file; then
        return 1
    fi

    local ids; ids=$(extract_message_ids_by_sender "$sender") || return 1

    print_table_header

    while IFS= read -r id; do
        extract_recipients_and_dates "$id"
    done <<< "$ids"
}

main "$@"

}

extract_message_ids_by_sender() {
    local sender="$1"
    local ids

    if ! ids=$(grep -E "postfix/(qmgr|cleanup).* from=<${sender}>" "$LOG_FILE" | awk '{print $6}' | sed 's/://g' | sort -u); then
        printf "Erro ao extrair IDs de mensagens\n" >&2
        return 1
    fi

    if [[ -z "$ids" ]]; then
        printf "Nenhuma mensagem encontrada para o remetente: %s\n" "$sender" >&2
        return 1
    fi

    printf "%s\n" "$ids"
}

extract_recipients_and_dates() {
    local message_id="$1"
    local entries

    if ! entries=$(grep -E "${message_id}: to=<" "$LOG_FILE"); then
        printf "Erro ao processar ID de mensagem: %s\n" "$message_id" >&2
        return 1
    fi

    if [[ -z "$entries" ]]; then
        return
    fi

    while IFS= read -r line; do
        local date; date=$(printf "%s\n" "$line" | awk '{printf "%s %s %s", $1, $2, $3}')
        local recipient; recipient=$(printf "%s\n" "$line" | sed -nE "s/.* to=<([^>]*)>.*/\1/p")
        if [[ -n "$recipient" ]]; then
            printf "%s\t%s\n" "$date" "$recipient"
        fi
    done <<< "$entries"
}

print_table_header() {
    printf "DATA\t\t\tDESTINATÁRIO\n"
    printf -- "-------------------------------\n"
}

main() {
    if [[ $# -ne 1 ]]; then
        printf "Uso: %s <remetente@dominio>\n" "$0" >&2
        return 1
    fi

    local sender="$1"

    if ! sanitize_input "$sender"; then
        return 1
    fi

    if ! check_log_file; then
        return 1
    fi

    local ids; ids=$(extract_message_ids_by_sender "$sender") || return 1

    print_table_header

    while IFS= read -r id; do
        extract_recipients_and_dates "$id"
    done <<< "$ids"
}

main "$@"
