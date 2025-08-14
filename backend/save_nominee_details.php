<?php
require_once 'config.php';

$input = json_decode(file_get_contents('php://input'), true);
if (!$input) sendJsonResponse(false, 'Invalid JSON payload', null);

if (empty($input['employee_code']) || !isset($input['nominees']) || !is_array($input['nominees'])) {
    sendJsonResponse(false, 'Missing employee_code or nominees array', null);
}

$employee_code = $input['employee_code'];
$nominees = $input['nominees'];

$total = 0.0;
foreach ($nominees as $n) {
    $total += isset($n['share_percentage']) ? floatval($n['share_percentage']) : 0.0;
}

if (count($nominees) > 1) {
    if (abs($total - 100.0) > 0.01) {
        sendJsonResponse(false, 'Total share percentage must equal 100', null);
    }
}

$pdo = getPDO();
try {
    $pdo->beginTransaction();
    $del = $pdo->prepare("DELETE FROM nominees WHERE employee_code = :ec");
    $del->execute([':ec' => $employee_code]);

    $ins = $pdo->prepare("INSERT INTO nominees (employee_code, name, relation, age, share_percentage) VALUES (:ec, :name, :relation, :age, :share)");
    $count = 0;
    foreach ($nominees as $n) {
        if (!is_array($n) || empty($n['name'])) continue;
        $ins->execute([
            ':ec' => $employee_code,
            ':name' => $n['name'],
            ':relation' => $n['relation'] ?? null,
            ':age' => isset($n['age']) ? intval($n['age']) : null,
            ':share' => floatval($n['share_percentage'])
        ]);
        $count++;
    }
    $pdo->commit();
    sendJsonResponse(true, 'Nominees saved', ['inserted_count' => $count]);
} catch (PDOException $e) {
    $pdo->rollBack();
    sendJsonResponse(false, 'Database error', ['error' => $e->getMessage()]);
}
