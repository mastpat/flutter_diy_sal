<?php
require_once 'config.php';

$inputRaw = file_get_contents('php://input');
$input = json_decode($inputRaw, true);
$employee_code = null;
if ($input && !empty($input['employee_code'])) {
    $employee_code = $input['employee_code'];
} else {
    // Allow GET with query param
    if (!empty($_GET['employee_code'])) $employee_code = $_GET['employee_code'];
}

if (!$employee_code) {
    sendJsonResponse(false, 'Missing employee_code', null);
}

$pdo = getPDO();
try {
    $stmt = $pdo->prepare("SELECT * FROM personal_details WHERE employee_code = :ec LIMIT 1");
    $stmt->execute([':ec' => $employee_code]);
    $personal = $stmt->fetch();

    $stmt = $pdo->prepare("SELECT * FROM address_details WHERE employee_code = :ec LIMIT 1");
    $stmt->execute([':ec' => $employee_code]);
    $address = $stmt->fetch();

    $stmt = $pdo->prepare("SELECT * FROM family_members WHERE employee_code = :ec");
    $stmt->execute([':ec' => $employee_code]);
    $family = $stmt->fetchAll();

    $stmt = $pdo->prepare("SELECT * FROM nominees WHERE employee_code = :ec");
    $stmt->execute([':ec' => $employee_code]);
    $nominees = $stmt->fetchAll();

    $stmt = $pdo->prepare("SELECT * FROM onboarding_status WHERE employee_code = :ec LIMIT 1");
    $stmt->execute([':ec' => $employee_code]);
    $onboarding = $stmt->fetch();

    sendJsonResponse(true, 'Summary fetched', [
        'personal' => $personal,
        'address' => $address,
        'family' => $family,
        'nominees' => $nominees,
        'onboarding' => $onboarding,
    ]);
} catch (PDOException $e) {
    sendJsonResponse(false, 'Database error', ['error' => $e->getMessage()]);
}
