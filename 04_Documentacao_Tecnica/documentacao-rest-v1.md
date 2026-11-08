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
| **Success Response** | **Code:** 200<br>**Content:** `[ { "id": 7, "nome": "Inês Pereira", "data_nascimento": "2009-02-21", "idade": 17, "genero": "F", "posicao": "Guarda-redes", "altura_cm": 172, "peso_kg": 61.3, "numero_camisola": 1, "id_equipa": 1, "equipa": "CF Benfica Sub-17 Femininos", "escalao": "Sub-17" }, ... ]` |
| **Error Response** | **Code:** 200<br>**Content:** objeto de erro do MySQL (por exemplo `{ "code": "ECONNREFUSED", ... }`) quando não há ligação à base de dados. |
| **Sample Call** | `curl http://localhost:3000/api/atletas`<br>Ou abrir o URL no browser ou no Postman (pedido GET). |


---

## Mostrar um atleta

| | |
|---|---|
| **Title** | Mostrar um atleta. Devolve a informação do atleta que corresponde ao id recebido, com a equipa atual. |
| **URL** | `/api/atletas/:id` |
| **Method** | `GET` |
| **URL Params** | **Required:**<br>`id=[integer]` — id do atleta (`id_utilizador`). Exemplo: `id=21` |
| **Data Params** | Nenhum. |
| **Success Response** | **Code:** 200<br>**Content:** `{ "id": 21, "nome": "Lara Natividade", "data_nascimento": "2007-06-30", "idade": 19, "genero": "F", "posicao": "Defesa", "altura_cm": 171, "peso_kg": 61, "numero_camisola": 14, "id_equipa": 3, "equipa": "CF Benfica Seniores Femininos", "escalao": "Seniores" }` |
| **Error Response** | **Code:** 200<br>**Content:** `{ "msg": "ERRO: Esse atleta não existe" }` — quando não existe atleta com esse id.<br><br>OR<br><br>**Code:** 200<br>**Content:** objeto de erro do MySQL quando não há ligação à base de dados. |
| **Sample Call** | `curl http://localhost:3000/api/atletas/21`<br>Ou abrir o URL no browser ou no Postman (pedido GET). |
