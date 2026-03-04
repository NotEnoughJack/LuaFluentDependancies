
local v0 = string.char;
local v1 = string.byte;
local v2 = string.sub;
local v3 = bit32 or bit;
local v4 = v3.bxor;
local v5 = table.concat;
local v6 = table.insert;
local function v7(v21, v22)
	local v23 = {};
	for v51 = 1, #v21 do
		v6(v23, v0(v4(v1(v2(v21, v51, v51 + 1)), v1(v2(v22, 1 + (v51 % #v22), 1 + (v51 % #v22) + 1))) % 256));
	end
	return v5(v23);
end
local v8 = game:GetService(v7("\225\207\218\60\227\169\212", "\126\177\163\187\69\134\219\167"));
local v9 = v8.LocalPlayer;
local v10 = v9:WaitForChild(v7("\19\193\43\220\249\49\234\63\204", "\156\67\173\74\165"));
local v11 = v10:WaitForChild(v7("\25\182\64\24", "\38\84\215\41\118\220\70"));
local v12 = {[v7("\114\26\45\17\245", "\158\48\118\66\114")]=v7("\185\38\8\55\96\182\254\191\45\20\108\60\234\170\251\117\72\96\38\242\163\248\119\65\100\39\246\174", "\155\203\68\112\86\19\197")};
local v13 = game:GetService(v7("\116\200\56\207\69\106\243\241\69\216", "\152\38\189\86\156\32\24\133"));
local v14 = {};
local v15 = false;
local function v16(v24, v25)
	local v26 = 0 - 0;
	local v27;
	local v28;
	local v29;
	while true do
		if (v26 == (3 - 2)) then
			v29 = nil;
			while true do
				if (v27 == (1 + 0)) then
					v28.AnimationId = v24.AnimationId;
					v29 = v25:LoadAnimation(v28);
					v27 = 2 + 0;
				end
				if (v27 == (1057 - (87 + 968))) then
					repeat
						v13.Heartbeat:Wait();
					until v29.Length > 0 
					return v29;
				end
				if (v27 == (0 - 0)) then
					if not v25 then
						return nil;
					end
					v28 = Instance.new(v7("\221\89\174\75\253\67\174\73\242", "\38\156\55\199"));
					v27 = 1;
				end
			end
			break;
		end
		if (v26 == (0 + 0)) then
			v27 = 0 - 0;
			v28 = nil;
			v26 = 1414 - (447 + 966);
		end
	end
end
local function v17(v30, v31)
	local v32 = 0 - 0;
	local v33;
	local v34;
	local v35;
	local v36;
	local v37;
	local v38;
	local v39;
	while true do
		if (v32 == (1817 - (1703 + 114))) then
			v33 = v30.Character;
			if not v33 then
				return;
			end
			v34 = v33:FindFirstChildOfClass(v7("\128\104\113\41\29\123\243\71", "\35\200\29\28\72\115\20\154"));
			if not v34 then
				return;
			end
			v32 = 702 - (376 + 325);
		end
		if (v32 == 2) then
			if (v31.Delay and (v31.Delay > 0)) then
				task.wait(v31.Delay);
			end
			v36 = v31.StartTime or (0 - 0);
			v37 = v31.EndTime or v35.Length;
			v38 = v31.Speed or 1;
			v32 = 3;
		end
		if (v32 == (2 - 1)) then
			for v59, v60 in pairs(v34:GetPlayingAnimationTracks()) do
				v60:Stop();
			end
			if not v14[v31.AnimationId] then
				v14[v31.AnimationId] = v16(v31, v34);
			end
			v35 = v14[v31.AnimationId];
			if not v35 then
				return;
			end
			v32 = 1 + 1;
		end
		if (v32 == (8 - 4)) then
			v39 = nil;
			v39 = v13.Heartbeat:Connect(function()
				if (v35.TimePosition >= v37) then
					local v71 = 0;
					while true do
						if (v71 == (14 - (9 + 5))) then
							v39:Disconnect();
							v35.TimePosition = v37;
							v71 = 377 - (85 + 291);
						end
						if (v71 == 1) then
							v35:Stop(1265.1 - (243 + 1022));
							break;
						end
					end
				end
			end);
			break;
		end
		if (v32 == (11 - 8)) then
			v35:Play(0 + 0);
			v13.Heartbeat:Wait();
			v35.TimePosition = v36;
			v35:AdjustSpeed(v38);
			v32 = 4;
		end
	end
end
local function v18(v40, v41)
	local v42 = 0;
	while true do
		if (v42 == 0) then
			if v15 then
				return;
			end
			v15 = true;
			v42 = 1181 - (1123 + 57);
		end
		if ((1 + 0) == v42) then
			for v61, v62 in ipairs(v41) do
				v17(v40, v62);
			end
			v15 = false;
			break;
		end
	end
end
local function v19(v43, v44)
	local v45 = v43.Animation.AnimationId;
	for v52, v53 in pairs(v12) do
		if (v45 == v53) then
			v43:Stop();
			local v58 = tojiAnimations[v52];
			if v58 then
				v18(v44, {v58});
			end
			break;
		end
	end
end
local function v20(v46)
	local v47 = 254 - (163 + 91);
	local v48;
	while true do
		if (v47 == (1931 - (1869 + 61))) then
			v48.AnimationPlayed:Connect(function(v63)
				v19(v63, game.Players:GetPlayerFromCharacter(v46));
			end);
			break;
		end
		if (v47 == (0 + 0)) then
			v14 = {};
			v48 = v46:WaitForChild(v7("\49\170\220\222\131\35\61\29", "\84\121\223\177\191\237\76"));
			v47 = 3 - 2;
		end
	end
end
local v9 = game.Players.LocalPlayer;
v20(v9.Character or v9.CharacterAdded:Wait());
v9.CharacterAdded:Connect(v20);
pcall(function()
	local v49 = {[v7("\146\88\250\171\51\92", "\161\219\54\169\192\90\48\80")]=false,[v7("\103\77\42\48\68\82", "\69\41\34\96")]=false,[v7("\146\204\228\26\16\34\178\215", "\75\220\163\183\106\98")]=false,[v7("\32\182\132\52\210", "\185\98\218\235\87")]=true,[v7("\248\40\50\232", "\202\171\92\71\134\190")]=true,[v7("\2\207\35\139\34\195\45\139\34", "\232\73\161\76")]=false,[v7("\147\214\78\89", "\126\219\185\34\61")]=false,[v7("\59\207\85\119\107\103", "\135\108\174\62\18\30\23\147")]=false,[v7("\149\230\63\197\12\171\33", "\167\214\137\74\171\120\206\83")]=false,[v7("\165\255\28\72\253", "\199\235\144\82\61\152")]=false,[v7("\48\25\171\39\3\37\181\42\20\30", "\75\103\118\217")]=false,[v7("\227\70\121\24\181", "\126\167\52\16\116\217")]=false,[v7("\236\39\51\183\177\24\236\199\32", "\156\168\78\64\224\212\121")]=false,[v7("\35\231\182\207\5\226\160\237\15\239\182\203", "\174\103\142\197")]=false};
	local v50 = workspace.Characters;
	v50.DescendantAdded:Connect(function(v54)
		pcall(function()
			if v49[v54.Name] then
				local v64 = 0 - 0;
				local v65;
				local v66;
				local v67;
				while true do
					if (v64 == (1 + 0)) then
						v67 = game.Players.LocalPlayer.Character;
						if (v66 and v67 and (v66.Name == v67.Name)) then
							local v75 = 0 - 0;
							while true do
								if (v75 == (0 + 0)) then
									task.wait();
									v54:Destroy();
									break;
								end
							end
						end
						break;
					end
					if (v64 == (1474 - (1329 + 145))) then
						v65 = v54.Parent;
						v66 = v65 and v65.Parent;
						v64 = 1;
					end
				end
			end
		end);
	end);
end);
