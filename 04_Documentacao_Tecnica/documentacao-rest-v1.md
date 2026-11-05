# Documentação REST — Team Pulse (v1)

Formato: [Documenting your API (bocoup)](https://bocoup.com/blog/documenting-your-api).

Servidor local: `http://localhost:3000`. Os URLs abaixo não incluem esta raiz.

---

## Mostrar todos os atletas

| | |
|---|---|
| **Title** | Mostrar todos os atletas. Devolve a lista dos atletas com a equipa atual (inscrição sem data de saída), ordenada por equipa e número de camisola. |
| **URL** | `/api/atletas` |
| **Method** | `GET` |
| **URL Params** | Nenhum. |
| **Data Params** | Nenhum. |
| **Success Response** | **Code:** 200<br>**Content:** `[ { "id": 5, "nome": "Tiago Mendes", "data_nascimento": "2010-06-17", "idade": 16, "genero": "M", "posicao": "Guarda-redes", "altura_cm": null, "peso_kg": null, "numero_camisola": 1, "id_equipa": 1, "equipa": "CF Benfica Sub-17", "escalao": "Sub-17" }, ... ]` |
| **Error Response** | **Code:** 200<br>**Content:** objeto de erro do MySQL (por exemplo `{ "code": "ECONNREFUSED", ... }`) quando não há ligação à base de dados. |
| **Sample Call** | `curl http://localhost:3000/api/atletas`<br>Ou abrir o URL no browser ou no Postman (pedido GET). |
| **Notes** | 04/11/2026: nesta versão o erro é devolvido ao cliente para debug; numa versão seguinte será trocado por uma mensagem genérica. Não devolve email nem password. |

---

## Mostrar um atleta

| | |
|---|---|
| **Title** | Mostrar um atleta. Devolve a informação do atleta que corresponde ao id recebido, com a equipa atual. |
| **URL** | `/api/atletas/:id` |
| **Method** | `GET` |
| **URL Params** | **Required:**<br>`id=[integer]` — id do atleta (`id_utilizador`). Exemplo: `id=21` |
| **Data Params** | Nenhum. |
| **Success Response** | **Code:** 200<br>**Content:** `{ "id": 21, "nome": "Inês Carvalho", "data_nascimento": "2006-11-16", "idade": 19, "genero": "F", "posicao": "Guarda-redes", "altura_cm": 175, "peso_kg": 56, "numero_camisola": 1, "id_equipa": 3, "equipa": "CF Benfica Seniores Femininos", "escalao": "Seniores" }` |
| **Error Response** | **Code:** 200<br>**Content:** `{ "msg": "ERRO: Esse atleta não existe" }` — quando não existe atleta com esse id.<br><br>OR<br><br>**Code:** 200<br>**Content:** objeto de erro do MySQL quando não há ligação à base de dados. |
| **Sample Call** | `curl http://localhost:3000/api/atletas/21`<br>Ou abrir o URL no browser ou no Postman (pedido GET). |
| **Notes** | 04/11/2026: o id é passado à query com o placeholder `?` (evita SQL injection). As respostas de erro usam o código 200 e uma mensagem `msg`. |
