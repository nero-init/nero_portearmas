local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

----------------------------------

-- ▐▓█▀▀▀▀▀▀▀▀▀█▓▌░▄▄▄▄▄░
-- ▐▓█░░▀░░▀▄░░█▓▌░█▄▄▄█░
-- ▐▓█░░▄░░▄▀░░█▓▌░█▄▄▄█░  Script criado para a comunidade!: Meu discord !Nero#7017
-- ▐▓█▄▄▄▄▄▄▄▄▄█▓▌░█████░
-- ░░░░▄▄███▄▄░░░░░█████░

----------------------------------

-- Esse script simples cria etapas para o porte por set ingame, começando pelo Jurídico onde é setado o "Requerimento CRAF".

-----------------------------------------------------------------------------------------------------------------------------------------
-- Set inicial: Advogado
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("setcraf", function(source, args) --Comando de registro do processo
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"juridico.permissao") then --permissao do set inicial
		local user_id = parseInt(args[1])
		if vRP.getUserSource(user_id) then
			vRP.setUData(user_id,"vRP:arma:abertura",json.encode({possui = 1}))
			TriggerClientEvent("Notify",source,"sucesso","Requerimento criado para o ID: "..parseInt(args[1]).."")
			status = true
			TriggerEvent("Nporte:portearmas", source, user_id, status)
		else
			TriggerClientEvent("Notify", source, "negado","Cidadão não se encontra presente.")
		end
	else    
		TriggerClientEvent("Notify",source,"negado","Você não é um advogado!.")
	end  
end)

RegisterCommand("rporte",function(source,args) --remover porte
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		local nuser_id = parseInt(args[1])
		if vRP.getUserSource(nuser_id) then
			vRP.setUData(nuser_id,"vRP:arma:license",json.encode({possui = 0}))
			TriggerClientEvent("Notify",source,"sucesso","Porte De Arma removido do passaporte: "..parseInt(args[1]).."")
			status = false
			TriggerEvent("Nporte:portearmas", source, user_id, nuser_id, status)
		else
			TriggerClientEvent("Notify", source, "negado","Cidadão não localizado.")
		end
	else    
		TriggerClientEvent("Notify",source,"negado","Você não é um polícial")
	end  

end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- Set intermediário: Paramédico
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cirurgia',function(source,args,rawCommand)
	local source = source
    local user_id = vRP.getUserId(source)
	local nplayer = vRP.getUserSource(parseInt(args[1]))
	local nuser_id = vRP.getUserId(nplayer)
	local identityu = vRP.getUserIdentity(nuser_id)
    if args[1] then
        if vRP.hasPermission(user_id,"paramedico.permissao") or vRP.hasPermission(user_id,"owner.permissao") then
				local id = vRP.prompt(source,"Passaporte do(a) paciente:","")
				local tipo = vRP.prompt(source,"Tipo da prontuário (Laudo Médico/Consulta):","")
				local descricao = vRP.prompt(source,"Descrição:","")
				local atestado = vRP.prompt(source,"Atestado:","Não foi solicitado.")
				if id == "" or tipo == "" or descricao == "" then
					return
				end
				local paramid = vRP.getUserIdentity(user_id)
				local identity = vRP.getUserIdentity(parseInt(id))
				SendWebhookMessage(webhookprontuario,"```prolog\n[ --------------- Exame Psicotécnico - PORTE --------------- ]\nParamédico: ["..user_id.."] "..paramid.name.." "..paramid.firstname.." \nPaciente: ["..id.."] "..identity.name.." "..identity.firstname.."\nDescrição: "..descricao.."\nAtestado: "..atestado.." "..os.date("\nData: %d/%m/%Y - %H:%M:%S").." \r```")
			if vRP.request(nplayer,"Deseja pagar uma cirurgia no valor de <b>R$50000</b>?",30) then
				if vRP.tryFullPayment(nuser_id,1,(args[500000])) then --Aqui você seta o valor que o paramédico cobra.(R$1)
					vRP.giveBankMoney(user_id,1,(args[500000]))
					TriggerClientEvent('Notify',source,"sucesso","Recebeu <b>R$50000</b> de <b>"..identityu.name.. " "..identityu.firstname.."</b>.")
					if nuser_id then
						vRP.setUData(nuser_id,"vRP:spawnController",json.encode(0))
						TriggerClientEvent("Notify",user_id,"sucesso","Você fez uma <b>Cirurgia</b> no paciente: <b>"..identityu.name.. " "..identityu.firstname.."</b>.",5000)
					end	
				end
            else    
                TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
            end   
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Set Final: Policia
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("setporte", function(source, args) --Script (porte de armas) 
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		local user_id = parseInt(args[1])
		if vRP.getUserSource(user_id) then
			vRP.setUData(user_id,"vRP:arma:license",json.encode({possui = 1}))
			TriggerClientEvent("Notify",source,"sucesso","Porte De Arma adicionado ao passaporte: "..parseInt(args[1]).."")
			status = true
			TriggerEvent("Nporte:portearmas", source, user_id, status)
		else
			TriggerClientEvent("Notify", source, "negado","Cidadão não localizado.")
		end
	else    
		TriggerClientEvent("Notify",source,"negado","Você não é um polícial")
	end  
end)

RegisterCommand("rporte",function(source,args) --Remoção do porte
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		local nuser_id = parseInt(args[1])
		if vRP.getUserSource(nuser_id) then
			vRP.setUData(nuser_id,"vRP:arma:license",json.encode({possui = 0}))
			TriggerClientEvent("Notify",source,"sucesso","Porte De Arma removido do passaporte: "..parseInt(args[1]).."")
			status = false
			TriggerEvent("Nporte:portearmas", source, user_id, nuser_id, status)
		else
			TriggerClientEvent("Notify", source, "negado","Cidadão não localizado.")
		end
	else    
		TriggerClientEvent("Notify",source,"negado","Você não é um polícial")
	end  
end)

RegisterCommand("porte",function(source,args) -- Verifica se o player tem porte.
    local source = source
	local user_id = vRP.getUserId(source)
	local nuser_id = parseInt(args[1])
	if vRP.hasPermission(user_id,"policia.permissao") then
		if args[1] == nil then
			TriggerClientEvent("Notify", source, "negado","Cidadão não localizado.")
		else
			if vRP.getUserSource(nuser_id) then
	  			local consulta = vRP.getUData(nuser_id,"vRP:arma:license")
	  			local resultado = json.decode(consulta) or {}
				resultado.possui = resultado.possui or 0
				if resultado.possui == 1 then
					TriggerClientEvent("Notify",source,"sucesso","Cidadão possui porte de armas.")
				else
					TriggerClientEvent("Notify",source,"negado","Cidadão não possui porte de armas.")
				end
			else
				TriggerClientEvent("Notify", source, "negado","Cidadão não localizado.")
			end
		end
	else
		TriggerClientEvent("Notify",source,"negado","Você não é um polícial.")
	end 
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPRAR PORTE - Aqui você pode apenas atribuir um blip e o player compra o porte sem ter mais passos adicionais.
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("comprar-portearmas")
AddEventHandler("comprar-portearmas",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local consulta = vRP.getUData(user_id,"vRP:arma:license")
	local resultado = json.decode(consulta) or {}
	resultado.possui = resultado.possui or 0
	if user_id then
		if resultado.possui == 1 then
			TriggerClientEvent("Notify",source,"negado","Você já possui porte de arma.")
		else
			if vRP.tryPayment(user_id,150000) then --Aqui você pode alterar o valor do porte;
				TriggerClientEvent("Notify", source, "sucesso","Agora Você tem Um Porte Mentalise /mporte Para Chegar Seu Porte!")
				vRP.setUData(user_id,"vRP:arma:license",json.encode({possui = 1}))
				status = true
				TriggerEvent("Nporte:portearmas", source, user_id, user_id, status)
			else
				TriggerClientEvent("Notify", source, "negado","Você não tem dinheiro!")
			end
		end
	end
end)

RegisterCommand("mporte",function(source,args) --O player verifica se tem porte.
	local source = source
	local user_id = vRP.getUserId(source)
	local consulta = vRP.getUData(user_id,"vRP:arma:license")
	local resultado = json.decode(consulta) or {}
	resultado.possui = resultado.possui or 0
	if user_id then
		if resultado.possui == 1 then
			TriggerClientEvent("Notify",source,"sucesso","Você possui porte de arma.")
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui porte de arma.")
		end
	end
end)
