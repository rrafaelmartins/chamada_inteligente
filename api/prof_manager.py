from flask import request, jsonify
from app import  app


chamadas = []  # Lista para armazenar histórico de chamadas (placeholder)

@app.route('/agendar_chamada', methods=['POST'])
def agendar_chamada():
    # Apenas placeholders em lista
    start_time = request.json.get('start_time')
    end_time = request.json.get('end_time')
    chamadas.append({"start_time": start_time, "end_time": end_time})
    return jsonify({"status": "success", "message": "chamada agendada com sucesso"}), 200

@app.route('/iniciar_chamada/<int:chamada_id>', methods=['POST'])
def iniciar_chamada(chamada_id):
    # Apenas placeholders
    if chamada_id < len(chamadas):
        return jsonify({"status": "success", "message": "chamada started"}), 200
    return jsonify({"status": "error", "message": "Invalid chamada ID"}), 404

@app.route('/terminar_chamada/<int:chamada_id>', methods=['POST'])
def terminar_chamada(chamada_id):
    # Apenas placeholders
    if chamada_id < len(chamadas):
        del chamadas[chamada_id]
        return jsonify({"status": "success", "message": "chamada ended"}), 200
    return jsonify({"status": "error", "message": "Invalid chamada ID"}), 404

@app.route('/historico_de_chamadas', methods=['GET'])
def historico_de_chamadas():
    return jsonify(chamadas), 200

if __name__ == '__main__':
    app.run(debug=True)
