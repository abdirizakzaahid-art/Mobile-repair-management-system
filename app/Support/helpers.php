<?php

use Illuminate\Support\Facades\DB;

function current_user(): ?array { return session('user'); }
function is_role(string ...$roles): bool { return current_user() && in_array(current_user()['role'], $roles, true); }
function money(mixed $amount): string { return '$'.number_format((float) $amount, 2); }
function status_badge(string $status): string {
    $colors = ['pending'=>'warning','under_diagnosis'=>'info','repairing'=>'primary','waiting_parts'=>'secondary','completed'=>'success','collected'=>'dark','cancelled'=>'danger','paid'=>'success','partial'=>'warning','unpaid'=>'danger','active'=>'success','inactive'=>'secondary'];
    return '<span class="badge text-bg-'.($colors[$status] ?? 'secondary').'">'.e(ucwords(str_replace('_', ' ', $status))).'</span>';
}
function generate_code(string $prefix): string { return strtoupper($prefix).now()->format('ymd').strtoupper(substr(bin2hex(random_bytes(3)), 0, 5)); }
function log_activity(string $action, string $type, ?int $id = null, ?string $description = null): void {
    DB::table('activity_logs')->insert(['user_id'=>current_user()['id'] ?? null,'action'=>$action,'entity_type'=>$type,'entity_id'=>$id,'description'=>$description,'ip_address'=>request()->ip(),'created_at'=>now()]);
}
function get_setting(string $key, string $default = ''): string { return (string) (DB::table('settings')->where('setting_key', $key)->value('setting_value') ?? $default); }
function create_notification(int $repairId, int $customerId, string $subject, string $message): void {
    $email = DB::table('customers')->where('id', $customerId)->value('email');
    DB::table('notifications')->insert(['repair_id'=>$repairId,'customer_id'=>$customerId,'channel'=>'email','recipient'=>$email,'subject'=>$subject,'message'=>$message,'delivery_status'=>'logged','sent_at'=>now(),'created_at'=>now()]);
}
