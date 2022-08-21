function [hash_key, hash_value] = create_hash_tags(anchor_points, df_hash, dt_hash, k)
    hash_key = [];
    hash_value = [];
    for i = 1:length(anchor_points)
        j = i;
        while (j <= length(anchor_points) && ...
                anchor_points(j,2) <= anchor_points(i,2) + dt_hash)
            if (anchor_points(j,1) <= anchor_points(i,1) + df_hash && ...
                anchor_points(j,1) >= anchor_points(i,1) - df_hash && ...
                anchor_points(j,2) > anchor_points(i,2))
                hash_key = [hash_key; [anchor_points(i, 1), anchor_points(j, 1), anchor_points(j, 2)-anchor_points(i, 2)]];
                hash_value = [hash_value; [k, anchor_points(i, 2)]];
            end
            j = j+1;
        end
    end
end