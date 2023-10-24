
from flask import request, jsonify
from app import  app

# Placeholders. Na realidade, isso virá do banco de dados
turmas = [
    {'codigo': 'TCC00123', 'nome': 'Introdução à Programação', 'turma': 'Turma A1 - 2023.2'},
    {'codigo': 'TCC00456', 'nome': 'Banco de Dados', 'turma': 'Turma B1 - 2023.2'}
]

presencas = {}  # Dicionario pra armazenar presença (key: turma code, value: presence status)

@app.route('/list_turmas', methods=['GET'])
def list_turmas():
    return jsonify(turmas), 200

@app.route('/confirmar_presenca/<string:codigo_turma>', methods=['POST'])
def confirmar_presenca(codigo_turma):
    presence_status = request.json.get('presence')
    presencas[codigo_turma] = presence_status
    return jsonify({"status": "success", "message": f"Presence for {codigo_turma} marked as {presence_status}"}), 200

if __name__ == '__main__':
    app.run(debug=True)
