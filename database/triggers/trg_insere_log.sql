-- Este script cria uma trigger para registrar automaticamente as alterações de status dos pedidos na tabela log_status_pedido_tb.

-- 1. Cria ou atualiza a função da Trigger
CREATE OR REPLACE FUNCTION public.fn_log_status_pedido()
RETURNS TRIGGER AS $$
BEGIN
    -- Caso 1: Criação de um novo pedido (INSERT)
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO public.log_status_pedido_tb (
            pedido_id,
            status_novo_id,
            data_hora_mudanca,
            observacao
        ) VALUES (
            NEW.pedido_id,
            NEW.status_id,
            NOW(),
            'Pedido criado no sistema.'
        );
        RETURN NEW;

    -- Caso 2: Alteração de status em um pedido existente (UPDATE)
    ELSIF (TG_OP = 'UPDATE') THEN
        -- Registra o log apenas se o status_id realmente mudou
        IF (OLD.status_id IS DISTINCT FROM NEW.status_id) THEN
            INSERT INTO public.log_status_pedido_tb (
                pedido_id,
                status_novo_id,
                data_hora_mudanca,
                observacao
            ) VALUES (
                NEW.pedido_id,
                NEW.status_id,
                NOW(),
                'Status do pedido atualizado.'
            );
            
            -- Atualiza automaticamente a coluna data_atualizacao no pedido
            NEW.data_atualizacao = NOW();
        END IF;
        RETURN NEW;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Cria a Trigger associada à tabela pedido_tb
CREATE TRIGGER trg_log_status_pedido
AFTER INSERT OR UPDATE ON public.pedido_tb
FOR EACH ROW
EXECUTE FUNCTION public.fn_log_status_pedido();