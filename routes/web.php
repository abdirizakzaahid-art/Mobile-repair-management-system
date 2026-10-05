<?php
use App\Http\Controllers\AuthController;
use App\Http\Controllers\MrmsController;
use App\Http\Controllers\OfficeController;
use Illuminate\Support\Facades\Route;

Route::redirect('/', '/login');
Route::get('/login',[AuthController::class,'form'])->name('login');
Route::post('/login',[AuthController::class,'login'])->name('login.submit');
Route::match(['get','post'],'/track',[MrmsController::class,'track'])->name('track');
Route::middleware('login.required')->group(function(){
 Route::post('/logout',[AuthController::class,'logout'])->name('logout');
 Route::get('/dashboard',[MrmsController::class,'dashboard'])->name('dashboard');
 Route::get('/repairs',[MrmsController::class,'repairs'])->name('repairs.index');
 Route::get('/repairs/{id}',[MrmsController::class,'repairShow'])->whereNumber('id')->name('repairs.show');
 Route::get('/repairs/{id}/update',[MrmsController::class,'repairEdit'])->whereNumber('id')->name('repairs.edit');
 Route::put('/repairs/{id}',[MrmsController::class,'repairUpdate'])->whereNumber('id')->name('repairs.update');
 Route::middleware('role:admin,receptionist')->group(function(){
  Route::get('/customers',[MrmsController::class,'customers'])->name('customers.index');
  Route::get('/customers/create',[MrmsController::class,'customerCreate'])->name('customers.create'); Route::post('/customers',[MrmsController::class,'customerStore'])->name('customers.store');
  Route::get('/customers/{id}',[MrmsController::class,'customerShow'])->whereNumber('id')->name('customers.show'); Route::post('/customers/{id}/devices',[MrmsController::class,'customerDevice'])->whereNumber('id')->name('customers.devices');
  Route::get('/customers/{id}/edit',[MrmsController::class,'customerEdit'])->whereNumber('id')->name('customers.edit'); Route::put('/customers/{id}',[MrmsController::class,'customerUpdate'])->whereNumber('id')->name('customers.update');
  Route::get('/repairs/create/new',[MrmsController::class,'repairCreate'])->name('repairs.create'); Route::post('/repairs',[MrmsController::class,'repairStore'])->name('repairs.store');
  Route::get('/invoices',[OfficeController::class,'invoices'])->name('invoices.index'); Route::get('/invoices/create/new',[OfficeController::class,'invoiceCreate'])->name('invoices.create'); Route::post('/invoices',[OfficeController::class,'invoiceStore'])->name('invoices.store'); Route::get('/invoices/{id}',[OfficeController::class,'invoiceShow'])->whereNumber('id')->name('invoices.show'); Route::post('/invoices/{id}/payments',[OfficeController::class,'payment'])->whereNumber('id')->name('invoices.payment');
  Route::get('/notifications',[OfficeController::class,'notifications'])->name('notifications');
 });
 Route::middleware('role:admin')->group(function(){Route::get('/inventory',[MrmsController::class,'inventory'])->name('inventory');Route::post('/inventory',[MrmsController::class,'inventoryStore'])->name('inventory.store');Route::post('/repairs/{id}/parts',[MrmsController::class,'addPart'])->whereNumber('id')->name('repairs.parts');Route::get('/technicians',[OfficeController::class,'technicians'])->name('technicians');Route::get('/reports',[OfficeController::class,'reports'])->name('reports');Route::get('/users',[OfficeController::class,'users'])->name('users.index');Route::get('/users/create',[OfficeController::class,'userCreate'])->name('users.create');Route::post('/users',[OfficeController::class,'userStore'])->name('users.store');Route::patch('/users/{id}/status',[OfficeController::class,'userStatus'])->name('users.status');Route::get('/settings',[OfficeController::class,'settings'])->name('settings');Route::put('/settings',[OfficeController::class,'settingsUpdate'])->name('settings.update');});
});
