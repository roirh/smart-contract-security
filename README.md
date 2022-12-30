# Análisis de seguridad en los Smart Contracts
## Smart contract security analysis

Este repositorio contiene los documentos asociados al TFM "Análisis de seguridad en los Smart Contracts" realizado para el Máster Universitario en Ciberseguridad y Privacidad ofertado por la Universidad Oberta de Catalunya.

- **docs**: memoria del proyecto
- **contracts**: contratos de ejemplo del trabajo. Incluye patrones de diseño recomendados y antipatrones con vulnerabilidades, que son analizados en la memoria.
  - *reentrancy*: ejemplo contrato inseguro a reentrada (bank_unsafe.sol) y dos soluciones:
    - Patrón Check, Effects, Interact (bank_with_pattern.sol)
    - Mutex lock con @OpenZepeling/ReentrancyGuard.sol (bank_with_mutex.sol)
  - *send_ether*: Ejemplos envio ether de forma segura, evitando reentrada y bloqueos de estado del contrato. Ejemplo inseguro a bloqueo (auction_unsafe.sol) aunque seguro a reentrada
    - Patrón retirada (Withdraw pattern) (witdraw_pattern_simple.sol)
    - Uso del patrón Check, Effects, Interact y patrón retirada (auction_withdraw.sol)
    - Resumen send(), transfer(), call() (send_ether.sol)
- **tests**: ejemplos de test para alguno de los contratos presentados