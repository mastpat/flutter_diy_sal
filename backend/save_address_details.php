<?php
require_once 'config.php';

$input = json_decode(file_get_contents('php://input'), true);
if (!$input) sendJsonResponse(false, 'Invalid JSON payload', null);

$required = ['employee_code', 'address1', 'city', 'state', 'district', 'pincode'];
foreach ($required as $r) {
    if (empty($input[$r])) sendJsonResponse(false, "Missing required field: $r", null);
}

$employee_code = $input['employee_code'];
$address1 = $input['address1'];
$address2 = $input['address2'] ?? null;
$city = $input['city'];
$state = $input['state'];
$district = $input['district'];
$pincode = $input['pincode'];
$landmark = $input['landmark'] ?? null;

if (!preg_match('/^\d{6}$/', $pincode)) {
    sendJsonResponse(false, 'Invalid pincode format', null);
}

$pdo = getPDO();
try {
    $stmt = $pdo->prepare("SELECT id FROM address_details WHERE employee_code = :ec LIMIT 1");
    $stmt->execute([':ec' => $employee_code]);
    $existing = $stmt->fetch();
    if ($existing) {
        $id = $existing['id'];
        $up = $pdo->prepare("UPDATE address_details SET address1=:a1, address2=:a2, city=:city, state=:state, district=:district, pincode=:pincode, landmark=:landmark WHERE id=:id");
        $up->execute([
            ':a1' => $address1,
            ':a2' => $address2,
            ':city' => $city,
            ':state' => $state,
            ':district' => $district,
            ':pincode' => $pincode,
            ':landmark' => $landmark,
            ':id' => $id
        ]);
        sendJsonResponse(true, 'Address updated', ['id' => $id]);
    } else {
        $ins = $pdo->prepare("INSERT INTO address_details (employee_code, address1, address2, city, state, district, pincode, landmark) VALUES (:ec, :a1, :a2, :city, :state, :district, :pincode, :landmark)");
        $ins->execute([
            ':ec' => $employee_code,
            ':a1' => $address1,
            ':a2' => $address2,
            ':city' => $city,
            ':state' => $state,
            ':district' => $district,
            ':pincode' => $pincode,
            ':landmark' => $landmark
        ]);
        $id = $pdo->lastInsertId();
        sendJsonResponse(true, 'Address saved', ['id' => (int)$id]);
    }
} catch (PDOException $e) {
    sendJsonResponse(false, 'Database error', ['error' => $e->getMessage()]);
}
