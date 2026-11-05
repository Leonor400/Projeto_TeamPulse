var pool = require("./connection");

// Lista de todos os atletas com a equipa atual
module.exports.getAllAtletas = async function() {
    try {
        const sql = "SELECT a.id_utilizador AS id, u.nome AS nome, " +
                    "DATE_FORMAT(a.data_nascimento, '%Y-%m-%d') AS data_nascimento, " +
                    "TIMESTAMPDIFF(YEAR, a.data_nascimento, CURDATE()) AS idade, " +
                    "a.genero AS genero, a.posicao_preferida AS posicao, " +
                    "a.altura_cm AS altura_cm, a.peso_kg AS peso_kg, " +
                    "i.numero_camisola AS numero_camisola, " +
                    "e.id_equipa AS id_equipa, e.nome AS equipa, e.escalao AS escalao " +
                    "FROM atleta a, utilizador u, inscricao i, equipa e " +
                    "WHERE u.id_utilizador = a.id_utilizador AND i.id_atleta = a.id_utilizador " +
                    "AND e.id_equipa = i.id_equipa AND i.data_saida IS NULL " +
                    "ORDER BY e.id_equipa, i.numero_camisola";
        const atletas = await pool.query(sql);
        return atletas;
    } catch (err) {
        console.log(err);
        return err;
    }
}

// Um atleta, pelo id
module.exports.getAtleta = async function(id) {
    try {
        const sql = "SELECT a.id_utilizador AS id, u.nome AS nome, " +
                    "DATE_FORMAT(a.data_nascimento, '%Y-%m-%d') AS data_nascimento, " +
                    "TIMESTAMPDIFF(YEAR, a.data_nascimento, CURDATE()) AS idade, " +
                    "a.genero AS genero, a.posicao_preferida AS posicao, " +
                    "a.altura_cm AS altura_cm, a.peso_kg AS peso_kg, " +
                    "i.numero_camisola AS numero_camisola, " +
                    "e.id_equipa AS id_equipa, e.nome AS equipa, e.escalao AS escalao " +
                    "FROM atleta a, utilizador u, inscricao i, equipa e " +
                    "WHERE u.id_utilizador = a.id_utilizador AND i.id_atleta = a.id_utilizador " +
                    "AND e.id_equipa = i.id_equipa AND i.data_saida IS NULL " +
                    "AND a.id_utilizador = ?";
        const atletas = await pool.query(sql, [ id ]);
        if (atletas.length > 0) return atletas[0];
        else return { msg: "ERRO: Esse atleta não existe" };
    } catch (err) {
        console.log(err);
        return err;
    }
}
