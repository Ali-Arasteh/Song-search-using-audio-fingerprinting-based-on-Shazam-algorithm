function anchor_points = find_anchor_points(time_freq_mat, dt, df)
    anchor_points = [];
    % sliding windows over time_freq_mat
    for j = 1:size(time_freq_mat, 2) % time
        for i = 1:size(time_freq_mat, 1) % freq
            selected_window = time_freq_mat(max(i-df, 1):min(i+df,size(time_freq_mat, 1)), ...
                              max(j-dt,1):min(j+dt,size(time_freq_mat, 2)));
            % check if time_freq_mat(i,j) has the maximum value in its specific sliding window
            if (time_freq_mat(i,j) == max(selected_window(:)))
                anchor_points = [anchor_points; [i, j]];
            end
        end
    end
end