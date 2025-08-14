<?php
require_once 'config.php';

$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
    sendJsonResponse(false, 'Invalid JSON payload', null);
}

$required = ['employee_code', 'first_name', 'dob', 'gender', 'phone'];
foreach ($required as $r) {
    if (empty($input[$r])) {
        sendJsonResponse(false, "Missing required field: $r", null);
    }
}

$employee_code = $input['employee_code'];
$first_name = $input['first_name'];
$last_name = $input['last_name'] ?? null;
$dob = $input['dob'];
$gender = $input['gender'];
$email = $input['email'] ?? null;
$phone = $input['phone'];

$pdo = getPDO();
try {
    // Check if exists
    $stmt = $pdo->prepare("SELECT id FROM personal_details WHERE employee_code = :ec LIMIT 1");
    $stmt->execute([':ec' => $employee_code]);
    $existing = $stmt->fetch();

    if ($existing) {
        $id = $existing['id'];
        $up = $pdo->prepare("UPDATE personal_details SET first_name=:fn, last_name=:ln, dob=:dob, gender=:gender, email=:email, phone=:phone WHERE id=:id");
        $up->execute([
            ':fn' => $first_name,
            ':ln' => $last_name,
            ':dob' => $dob,
            ':gender' => $gender,
            ':email' => $email,
            ':phone' => $phone,
            ':id' => $id
        ]);
        sendJsonResponse(true, 'Personal details updated', ['id' => $id]);
    } else {
        $ins = $pdo->prepare("INSERT INTO personal_details (employee_code, first_name, last_name, dob, gender, email, phone) VALUES (:ec, :fn, :ln, :dob, :gender, :email, :phone)");
        $ins->execute([
            ':ec' => $employee_code,
            ':fn' => $first_name,
            ':ln' => $last_name,
            ':dob' => $dob,
            ':gender' => $gender,
            ':email' => $email,
            ':phone' => $phone
        ]);
        $id = $pdo->lastInsertId();
        sendJsonResponse(true, 'Personal details saved', ['id' => (int)$id]);
    }
} catch (PDOException $e) {
    sendJsonResponse(false, 'Database error', ['error' => $e->getMessage()]);
}
