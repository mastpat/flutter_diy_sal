<?php
require_once 'config.php';

$input = json_decode(file_get_contents('php://input'), true);
if (!$input) sendJsonResponse(false, 'Invalid JSON payload', null);

if (empty($input['employee_code']) || !isset($input['members']) || !is_array($input['members'])) {
    sendJsonResponse(false, 'Missing employee_code or members array', null);
}

$employee_code = $input['employee_code'];
$members = $input['members'];

$pdo = getPDO();
try {
    $pdo->beginTransaction();
    $del = $pdo->prepare("DELETE FROM family_members WHERE employee_code = :ec");
    $del->execute([':ec' => $employee_code]);

    $ins = $pdo->prepare("INSERT INTO family_members (employee_code, name, relation, age, occupation) VALUES (:ec, :name, :relation, :age, :occupation)");
    $count = 0;
    foreach ($members as $m) {
        if (!is_array($m) || empty($m['name'])) continue;
        $ins->execute([
            ':ec' => $employee_code,
            ':name' => $m['name'],
            ':relation' => $m['relation'] ?? null,
            ':age' => isset($m['age']) ? intval($m['age']) : null,
            ':occupation' => $m['occupation'] ?? null
        ]);
        $count++;
    }
    $pdo->commit();
    sendJsonResponse(true, 'Family details saved', ['inserted_count' => $count]);
} catch (PDOException $e) {
    $pdo->rollBack();
    sendJsonResponse(false, 'Database error', ['error' => $e->getMessage()]);
}
