% distributive viterbi for 'N' states, 'M' sequences, 'O' emmision variables
% seq = M*O matrix, seq(i,:) = pd of 'O' emmision variables on sequence i
% trans = N*N matrix, trans(i,j) = probability from i state to j state
% emmi = N*O matrix, emmi(i,:) = pd of 'O' emmission variables on i state
% initial_state = initial state
% guess = M array, guess(i) = most probable state at sequence i
function [ guess ] = viterbi( seq, trans, emmi , state)
    M = size(seq, 1);
    O = size(seq, 2);
    N = size(trans, 1);
    if size(trans, 2) ~= N
        disp('transition matrix is not n*n');
        return
    end
    if size(emmi, 1) ~= N || size(emmi, 2) ~= O
        disp('emmision matrix is not N*O');
    end
    % V(i, j) = the prob of state j for [1..i] sequences
    V = zeros(M, N);
    V(1, state) = 1;
    guess = zeros(1, M);
    guess(1) = state;
    % V(t,k) = max(P(y_t|k)*trans(state,k)*V(t-1,k))
    for seq_i=2:M
        y = seq(seq_i,:)';
        max_prob = 0;
        best_state = 0;
        for next_state=1:N
            P = y*emmi(next_state,:);
            trans_prob = P*trans(state,next_state)*V(seq_i-1,next_state);
            if trans_prob > max_prob
                max_prob = trans_prob;
                best_state = next_state;
            end
        end
        state = best_state;
        guess(seq_i) = state;
    end
end

