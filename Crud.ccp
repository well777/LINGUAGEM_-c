#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_CONTATOS 100
#define MAX_NOME 50
#define MAX_TELEFONE 15

typedef struct {
    int id;
    char nome[MAX_NOME];
    char telefone[MAX_TELEFONE];
} Contato;

Contato contatos[MAX_CONTATOS];
int totalContatos = 0;

void carregarContatos() {
    FILE *arquivo = fopen("contatos.txt", "r");
    if (arquivo == NULL) return;

    while (fscanf(arquivo, "%d %[^\n] %[^\n]\n", &contatos[totalContatos].id, 
                  contatos[totalContatos].nome, contatos[totalContatos].telefone) != EOF) {
        totalContatos++;
    }
    fclose(arquivo);
}

void salvarContatos() {
    FILE *arquivo = fopen("contatos.txt", "w");
    if (arquivo == NULL) {
        printf("Erro ao abrir arquivo!\n");
        return;
    }

    for (int i = 0; i < totalContatos; i++) {
        fprintf(arquivo, "%d %s %s\n", contatos[i].id, contatos[i].nome, contatos[i].telefone);
    }
    fclose(arquivo);
}

void criarContato() {
    if (totalContatos >= MAX_CONTATOS) {
        printf("Limite de contatos atingido!\n");
        return;
    }

    Contato novo;
    novo.id = totalContatos + 1;
    printf("Digite o nome: ");
    getchar();
    fgets(novo.nome, MAX_NOME, stdin);
    novo.nome[strcspn(novo.nome, "\n")] = 0;
    printf("Digite o telefone: ");
    fgets(novo.telefone, MAX_TELEFONE, stdin);
    novo.telefone[strcspn(novo.telefone, "\n")] = 0;

    contatos[totalContatos] = novo;
    totalContatos++;
    salvarContatos();
    printf("Contato criado com sucesso!\n");
}

void listarContatos() {
    if (totalContatos == 0) {
        printf("Nenhum contato cadastrado.\n");
        return;
    }

    for (int i = 0; i < totalContatos; i++) {
        printf("ID: %d, Nome: %s, Telefone: %s\n", contatos[i].id, contatos[i].nome, contatos[i].telefone);
    }
}

void atualizarContato() {
    int id;
    printf("Digite o ID do contato a atualizar: ");
    scanf("%d", &id);

    for (int i = 0; i < totalContatos; i++) {
        if (contatos[i].id == id) {
            printf("Digite o novo nome: ");
            getchar();
            fgets(contatos[i].nome, MAX_NOME, stdin);
            contatos[i].nome[strcspn(contatos[i].nome, "\n")] = 0;
            printf("Digite o novo telefone: ");
            fgets(contatos[i].telefone, MAX_TELEFONE, stdin);
            contatos[i].telefone[strcspn(contatos[i].telefone, "\n")] = 0;
            salvarContatos();
            printf("Contato atualizado com sucesso!\n");
            return;
        }
    }
    printf("Contato não encontrado.\n");
}

void deletarContato() {
    int id;
    printf("Digite o ID do contato a deletar: ");
    scanf("%d", &id);

    for (int i = 0; i < totalContatos; i++) {
        if (contatos[i].id == id) {
            for (int j = i; j < totalContatos - 1; j++) {
                contatos[j] = contatos[j + 1];
                contatos[j].id = j + 1;
            }
            totalContatos--;
            salvarContatos();
            printf("Contato deletado com sucesso!\n");
            return;
        }
    }
    printf("Contato não encontrado.\n");
}

int main() {
    carregarContatos();
    int opcao;

    do {
        printf("\n=== Sistema CRUD de Contatos ===\n");
        printf("1. Criar contato\n");
        printf("2. Listar contatos\n");
        printf("3. Atualizar contato\n");
        printf("4. Deletar contato\n");
        printf("5. Sair\n");
        printf("Escolha uma opcao: ");
        scanf("%d", &opcao);

        switch (opcao) {
            case 1: criarContato(); break;
            case 2: listarContatos(); break;
            case 3: atualizarContato(); break;
            case 4: deletarContato(); break;
            case 5: printf("Saindo...\n"); break;
            default: printf("Opcao invalida!\n");
        }
    } while (opcao != 5);

    return 0;
}
