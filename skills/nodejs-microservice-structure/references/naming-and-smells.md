# Node.js Microservice Naming And Smells

Use this reference when renaming files, reviewing technical-layer buckets, or
creating structural lint rules.

## Naming

Use PascalCase for primary named concepts.

Required suffixes when applicable:

```text
Controller Routes Middleware ApplicationService Command Query Ports Contract Dto Mapper Repository Client Publisher Consumer Policy DomainService Event Error Type
```

Examples:

```text
BookingController.ts
BookingRoutes.ts
CreateBookingApplicationService.ts
CreateBookingCommand.ts
FindAvailabilityQuery.ts
BookingPorts.ts
CreateBookingRequestContract.ts
BookingContractMapper.ts
FirestoreBookingRepository.ts
SchedulingHttpClient.ts
BookingPolicy.ts
BookingConflictError.ts
```

Avoid vague names:

```text
utils.ts helpers.ts common.ts types.ts interfaces.ts service.ts manager.ts processor.ts handler.ts misc.ts shared.ts
```

Use `Handler` only when qualified, such as `InboundCallWebhookHandler.ts`. Use
`index.ts` only for intentional module entrypoints; avoid broad barrels.

## Technical-Layer Smells

These global folders are smells unless the service is tiny:

```text
src/controllers src/services src/repositories src/dtos src/types src/interfaces src/exceptions src/enums src/mappers src/middlewares
```

Prefer:

- `exceptions/` -> `errors/`
- `interfaces/` -> `contracts/` or `application/*Ports.ts`
- `services/` -> `application/` or `domain/`
- `types/` -> named files near owner
- `enums/` -> domain value objects/literal unions near owner
- `repositories/` -> `infrastructure/`
- `middlewares/` -> `app/` or module `presentation/`
